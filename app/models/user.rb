class User < ::ApplicationBase
  class RegistrationDenied < ::RuntimeError; end

  PASSWORD_RESET_EXPIRY = 1.hour

  has_secure_password

  has_many :meals, class_name: '::FoodMenus::Meal', dependent: :destroy
  has_many :recipes, class_name: '::FoodMenus::Recipe', dependent: :destroy
  has_many :ingredients, class_name: '::FoodMenus::Ingredient', dependent: :destroy
  has_many :suppliers, class_name: '::FoodMenus::Supplier', dependent: :destroy
  has_many :menu_rotations, class_name: '::FoodMenus::MenuRotation', dependent: :destroy
  has_one :setting, class_name: '::FoodMenus::Setting', dependent: :destroy
  has_one :shopping_list, class_name: '::FoodMenus::ShoppingList', dependent: :destroy

  has_many :accounts, class_name: '::Budgets::Account', dependent: :destroy

  attr_accessor :old_password, :email_is_valid, :email_validator_message

  default_scope { where(account_closed: false) }

  # No need to validate password field - included in secure_password

  validates :password_confirmation,
            presence: { if: -> { password.present? } }

  validates :email,
            presence: true,
            format: /@/,
            confirmation: { if: :email_changed? },
            email:  { if: :email_changed? }

  validate :email_is_unique

  validates :email_confirmation,
            presence: { if: :email_changed? }

  validates :first_name,
            presence: true, length: { maximum: 35 }

  validates :last_name,
            presence: true, length: { maximum: 40 }

  def display_name
    [first_name, last_name].compact.join(' ')
  end

  def display_type
    self.type.demodulize.underscore.humanize.titleize
  end

  def to_s
    display_name
  end

  def full_name
    [last_name, first_name].compact.join(', ')
  end

  # Returns true / false / nil - nil if user doesn't have previous password
  def authenticate_with_md5(pwd)
    if old_password_digest.present?
      Digest::MD5.hexdigest(pwd) == old_password_digest
    end
  end

  def migrate_password!(pwd)
    self.password = pwd
    self.password_confirmation = pwd
    self.old_password_digest = nil
    save!(validate: false)
  end

  def set_password_token!(valid_for = PASSWORD_RESET_EXPIRY)
    assign_attributes(get_password_token_attributes(valid_for))
    save(validate: false)
  end

  def get_password_token_attributes(valid_for = PASSWORD_RESET_EXPIRY)
    { password_token: SecureRandom.base64(32).tr('/', '_').gsub(/[=+]/, ''),
      password_recovery_sent_at: Time.now,
      password_token_expires: Time.now + valid_for }
  end

  def get_day_week_by_date(the_date)
    @setting = setting
    day_diff = (the_date - @setting.menu_rotation_start_date).to_i
    week = (((day_diff / 7) + 1 )% -@setting.menu_rotation_weeks) + @setting.menu_rotation_weeks
    day = ((day_diff + 1) % - 7) + 7
    {week: week, day: day}
  end

  def process_menu_rotations
    # Create new ones if they don't already exist
    @setting = setting
    (1..@setting.menu_rotation_weeks).each do |menu_rotation_week|
      (1..7).each do |menu_rotation_day|
        next if menu_rotations.where("week = ? AND day = ?", menu_rotation_week, menu_rotation_day).any?
        menu_rotations.create(week: menu_rotation_week, day: menu_rotation_day)
      end
    end

    # Remove ones that are no longer needed
    menu_rotations.all.each do |menu_rotation|
      menu_rotation.destroy unless (1..@setting.menu_rotation_weeks).include?(menu_rotation.week)
    end
  end

  def get_rotation_by_date(the_date)
    h = get_day_week_by_date(the_date)
    menu_rotations.where("week = ? AND day = ?", h[:week], h[:day]).first
  end

  def method_missing(m, *args, &block)
    # Use this so we don't have to create a new method every time we add to PAYMENT_TYPES
    if m.to_s =~ /^pay_(.+)\?$/
      run_pay_method(Regexp.last_match(1), *args, &block)
    else
      super
    end
  end

  def self.permitted_attributes
    # Include nested attributes
    super + [
      "password", "password_confirmation", "email_confirmation"
    ]
  end

  private

  # @ Validates that the email is unique and if not sets an error message. The message is
  # different if the existing account is closed
  def email_is_unique
    # Search unscoped customer to include closed account
    if (existing = User.unscoped.find_by_email(email)) && (id.nil? || (id != existing.id))
      msg = if existing.account_closed?
              "We're unable to create an account using this email address. Please contact customer services."
            else
              'An account already exists for this email address.'
            end
      errors.add(:email, msg)
    end
  end
end

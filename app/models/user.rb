class User < ::ApplicationBase
  class RegistrationDenied < ::RuntimeError; end

  PASSWORD_RESET_EXPIRY = 1.hour

  has_secure_password

  has_many :meals, class_name: '::Meal', dependent: :destroy
  has_many :recipes, class_name: '::Recipe', dependent: :destroy
  has_many :ingredients, class_name: '::Ingredient', dependent: :destroy
  has_many :suppliers, class_name: '::Supplier', dependent: :destroy
  has_many :menu_rotations, class_name: '::MenuRotation', dependent: :destroy
  has_many :shopping_lists, class_name: '::ShoppingList', dependent: :destroy
  has_many :shopping_list_days, class_name: '::ShoppingListDay', dependent: :destroy

  has_many :accounts, class_name: '::Budgets::Account', dependent: :destroy

  attr_accessor :old_password, :email_is_valid, :email_validator_message

  WEEKS = [1,2,3,4]

  DAYS =
    {
      1 => "Sunday",
      2 => "Monday",
      3 => "Tuesday",
      4 => "Wednesday",
      5 => "Thursday",
      6 => "Friday",
      7 => "Saturday"
    }

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

  validates :menu_rotation_weeks, numericality: { greater_than: 0 }
  validates_presence_of :menu_rotation_weeks, :menu_rotation_start_date

  after_create :create_dependencies

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
    day_diff = (the_date - menu_rotation_start_date).to_i
    week = (((day_diff / 7) + 1 )% -menu_rotation_weeks) + menu_rotation_weeks
    day = ((day_diff + 1) % - 7) + 7
    {week: week, day: day}
  end

  def shopping_list
    shopping_lists.last
  end

  def process_menu_rotations
    # Create new ones if they don't already exist
    (1..menu_rotation_weeks).each do |menu_rotation_week|
      (1..7).each do |menu_rotation_day|
        next if menu_rotations.where("week = ? AND day = ?", menu_rotation_week, menu_rotation_day).any?
        menu_rotations.create(week: menu_rotation_week, day: menu_rotation_day)
      end
    end

    # Remove ones that are no longer needed
    menu_rotations.all.each do |menu_rotation|
      menu_rotation.destroy unless (1..menu_rotation_weeks).include?(menu_rotation.week)
    end
  end

  def get_rotation_by_date(the_date)
    h = get_day_week_by_date(the_date)
    menu_rotations.where("week = ? AND day = ?", h[:week], h[:day]).first
  end


  def build_shopping_list_days(start_date, end_date)
    shopping_list_days.destroy_all

    (start_date..end_date).each do |the_date|

      shopping_list_day = shopping_list_days.create(the_date: the_date)

      menu_rotation = get_rotation_by_date(the_date)

      if menu_rotation.present?
        menu_rotation.collection_meals.each do |meal|
          shopping_list_day.collection_meals.create(meal.dup.attributes)
        end

        menu_rotation.collection_recipes.each do |recipe|
          shopping_list_day.collection_recipes.create(recipe.dup.attributes)
        end

        menu_rotation.collection_ingredients.each do |ingredient|
          shopping_list_day.collection_ingredients.create(ingredient.dup.attributes)
        end
      end
    end
  end


  def build_shopping_list
    shopping_list.collection_ingredients.unscoped.where(target: shopping_list).destroy_all

    if shopping_list_days.present?
      shopping_list_days.each do |shopping_list_day|
        if shopping_list_day.present?
          shopping_list_day.get_all_ingredients.each do |col_ingredient|
            add_shopping_list_ingredient(col_ingredient)
          end
        end
      end
    end
  end

  def add_shopping_list_ingredient(new_ingredient)
    new_ingredient = align_to_purchase_unit(new_ingredient)
    if (existing = shopping_list.collection_ingredients.find_by(ingredient_id: new_ingredient.ingredient_id, unit_id: new_ingredient.unit_id)).present?
      existing.update_attributes(quantity: (existing.quantity + new_ingredient.quantity))
    else
      shopping_list.collection_ingredients.create(ingredient_id: new_ingredient.ingredient_id, unit_id: new_ingredient.unit_id, quantity: new_ingredient.quantity)
    end
  end

  def align_to_purchase_unit(new_ingredient)
    ingredient_unit = new_ingredient.unit
    purchase_unit = new_ingredient.ingredient.unit

    if purchase_unit.present?
      new_ingredient.unit = purchase_unit
      new_ingredient.quantity = new_ingredient.quantity / purchase_unit.conversion_rate * ingredient_unit.conversion_rate
    end

    return new_ingredient
  end

  def get_all_ingredients(ingredient_id = 0, unit_id = 0)
    all_ingredients = []

    if shopping_list_days.present?
      shopping_list_days.each do |shopping_list_day|
        all_ingredients += shopping_list_day.get_all_ingredients(ingredient_id, unit_id)
      end
    end

    return all_ingredients
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

  def create_dependencies
    ShoppingList.create(user_id: self.id, start_date: menu_rotation_start_date, end_date: menu_rotation_start_date + (default_shopping_days - 1).day) unless shopping_list.present?
  end
end
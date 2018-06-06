module FoodMenus
  class Ingredient < ::ApplicationBase

    belongs_to :user
    belongs_to :unit

    has_one :collection, as: :target, dependent: :destroy
    after_create :create_collection

    has_many :ingredient_suppliers, dependent: :destroy
    has_many :suppliers, through: :ingredient_suppliers

    validates :name, presence: true
    validates_uniqueness_of :name, scope: :user_id

    default_scope { order(:name) }

    def to_s
      if self.quantity && self.quantity > 0
      "#{self.name} (#{self.quantity}#{self.unit.try(:abbreviation)})"
      else
        self.name
      end
    end
  end
end
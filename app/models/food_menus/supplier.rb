module FoodMenus
  class Supplier < ::ApplicationBase

    belongs_to :user
    has_many :ingredient_suppliers, dependent: :destroy
    has_many :ingredients, through: :ingredient_suppliers

    validates :name, presence: true
    validates_uniqueness_of :name, scope: :user_id

    default_scope { order(:name) }

  end
end
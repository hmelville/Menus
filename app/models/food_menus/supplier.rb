module FoodMenus
  class Supplier < ::ApplicationBase

    belongs_to :user
    has_many :ingredient_suppliers, dependent: :destroy
    has_many :ingredients, through: :ingredient_suppliers

    validates :name, presence: true
    validates_uniqueness_of :user_id, :name

    default_scope { order(:name) }

  end
end
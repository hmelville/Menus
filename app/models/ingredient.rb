class Ingredient < ::ApplicationBase

  belongs_to :user
  belongs_to :unit

  has_many :ingredient_suppliers, dependent: :destroy, class_name: 'Ingredients::IngredientSupplier'

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :user_id

  default_scope { order(:name) }

end
class Recipe < ::ApplicationBase

  belongs_to :user
  has_many :collection_ingredients, as: :target, dependent: :destroy
  has_many :ingredients, through: :collection_ingredients

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :user_id

  default_scope { order(:name) }

  def get_all_ingredients(ingredient_id = 0, unit_id = 0)
    collection_ingredients.where("(ingredient_id = ? OR ? = 0) AND (collection_ingredients.unit_id = ? OR ? = 0)", ingredient_id, ingredient_id, unit_id, unit_id)
  end
end
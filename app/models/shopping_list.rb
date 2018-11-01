class ShoppingList < ::ApplicationBase

  belongs_to :user

  has_many :collection_ingredients, as: :target, dependent: :destroy
  has_many :ingredients, through: :collection_ingredients

  after_create :build_shopping_list_days

  def soft_delete
    true
  end

  def get_all_ingredients(ingredient_id = 0, unit_id = 0)
    collection_ingredients.where("(ingredient_id = ? OR ? = 0) AND (collection_ingredients.unit_id = ? OR ? = 0)", ingredient_id, ingredient_id, unit_id, unit_id)
  end

end
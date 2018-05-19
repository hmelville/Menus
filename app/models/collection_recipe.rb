class CollectionRecipe < ActiveRecord::Base

  belongs_to :collection
  belongs_to :recipe

  default_scope { joins(:recipe).order("recipes.name") }

  def get_all_ingredients(ingredient_id = 0)
    return self.collection.collection_ingredients.where("ingredient_id = ? OR ? = 0", ingredient_id, ingredient_id)
  end
end
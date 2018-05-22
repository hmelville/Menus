module FoodMenus
  class CollectionMeal < ActiveRecord::Base

    belongs_to :collection
    belongs_to :meal

    default_scope { joins(:meal).order("meals.name") }

    def get_all_ingredients(ingredient_id = 0)
      all_ingredients = []

      recipes.each do |r|
        all_ingredients += r.collection.get_all_ingredients(ingredient_id)
      end

      all_ingredients += collection_ingredients.where("ingredient_id = ? OR ? = 0", ingredient_id, ingredient_id)

      return all_ingredients
    end
  end
end
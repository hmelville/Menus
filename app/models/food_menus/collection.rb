module FoodMenus
  class Collection < ActiveRecord::Base

    belongs_to :target, polymorphic: true

    has_many :collection_meals, dependent: :destroy
    has_many :meals, through: :collection_meals

    has_many :collection_recipes, dependent: :destroy
    has_many :recipes, through: :collection_recipes

    has_many :collection_ingredients, dependent: :destroy
    has_many :ingredients, through: :collection_ingredients

    def show_meals?
      %w(FoodMenus::Recipe FoodMenus::Meal FoodMenus::Ingredient).exclude?(self.target_type)
    end

    def show_recipes?
      %w(FoodMenus::Recipe FoodMenus::Ingredient).exclude?(self.target_type)
    end

    def get_all_ingredients(ingredient_id = 0)
      all_ingredients = []

      meals.each do |m|
        all_ingredients += m.collection.get_all_ingredients(ingredient_id)
      end

      recipes.each do |r|
        all_ingredients += r.collection.get_all_ingredients(ingredient_id)
      end

      all_ingredients += collection_ingredients.where("ingredient_id = ? OR ? = 0", ingredient_id, ingredient_id)

      return all_ingredients
    end
  end
end
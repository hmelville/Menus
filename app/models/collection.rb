class Collection < ::ApplicationBase


  has_many :collection_meals, dependent: :destroy
  has_many :meals, through: :collection_meals

  has_many :collection_recipes, dependent: :destroy
  has_many :recipes, through: :collection_recipes

  has_many :collection_ingredients, dependent: :destroy
  has_many :ingredients, through: :collection_ingredients

  def show_meals?
    %w(Recipe Meal Ingredient).exclude?(self.target_type)
  end

  def show_recipes?
    %w(Recipe Ingredient).exclude?(self.target_type)
  end

  def main_recipes
    recipes = []
    collection_meals.collect {|cm| recipes += cm.meal.collection.collection_recipes.collect{|mr| mr.recipe.name} }
    recipes += collection_recipes.collect {|cr| cr.recipe.name }
    return recipes.uniq.sort.to_sentence
  end

  def get_all_ingredients(ingredient_id = 0, unit_id = 0)
    all_ingredients = []

    meals.each do |m|
      all_ingredients += m.collection.get_all_ingredients(ingredient_id, unit_id)
    end

    recipes.each do |r|
      all_ingredients += r.collection.get_all_ingredients(ingredient_id, unit_id)
    end

    all_ingredients += collection_ingredients.where("(ingredient_id = ? OR ? = 0) AND (collection_ingredients.unit_id = ? OR ? = 0)", ingredient_id, ingredient_id, unit_id, unit_id)

    return all_ingredients
  end
end
class MealRecipe < ActiveRecord::Base
  belongs_to :meal
  belongs_to :recipe
  belongs_to :ingredient

  validates_presence_of :meal_id, :recipe_id

  default_scope { joins(:recipe).order("recipes.name") }

  def name
    self.recipe.name
  end
end

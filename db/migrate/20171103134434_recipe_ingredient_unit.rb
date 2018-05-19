class RecipeIngredientUnit < ActiveRecord::Migration
  def change
    add_column :recipe_ingredients, :unit_id, :integer
    add_column :ingredients, :purchase_unit_id, :integer
  end
end

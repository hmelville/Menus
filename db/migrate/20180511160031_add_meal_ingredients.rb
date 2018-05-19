class AddMealIngredients < ActiveRecord::Migration
  def change
    create_table :meal_ingredients do |t|
      t.integer :meal_id
      t.integer :ingredient_id
      t.integer :unit_id
      t.decimal :quantity, precision: 8, scale: 2
      t.timestamps
    end
  end
end

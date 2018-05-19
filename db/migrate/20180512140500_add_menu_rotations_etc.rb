class AddMenuRotationsEtc < ActiveRecord::Migration
  def change
    create_table :menu_rotation_meals do |t|
      t.integer :menu_rotation_id
      t.integer :meal_id
      t.timestamps
    end
    create_table :menu_rotation_recipes do |t|
      t.integer :menu_rotation_id
      t.integer :recipe_id
      t.timestamps
    end
    create_table :menu_rotation_ingredients do |t|
      t.integer :menu_rotation_id
      t.integer :ingredient_id
      t.integer :unit_id
      t.decimal :quantity, precision: 8, scale: 2
      t.timestamps
    end
  end
end

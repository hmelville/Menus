class AddCollections < ActiveRecord::Migration
  def change

    create_table    :collections do |t|
      t.string      :target_type
      t.integer     :target_id
      t.timestamps
    end

    create_table    :collection_meals do |t|
      t.integer     :collection_id
      t.integer     :meal_id
      t.timestamps
    end

    create_table    :collection_recipes do |t|
      t.integer     :collection_id
      t.integer     :recipe_id
      t.timestamps
    end

    create_table    :collection_ingredients do |t|
      t.integer     :collection_id
      t.integer     :ingredient_id
      t.integer     :unit_id
      t.decimal     :quantity, precision: 8, scale: 2
      t.timestamps
    end

    drop_table :menu_rotation_meals
    drop_table :menu_rotation_recipes
    drop_table :menu_rotation_ingredients
    drop_table :shopping_list_meals
    drop_table :shopping_list_recipes
    drop_table :shopping_list_ingredients

  end
end

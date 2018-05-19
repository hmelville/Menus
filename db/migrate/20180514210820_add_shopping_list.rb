class AddShoppingList < ActiveRecord::Migration
  def change

    create_table    :shopping_lists do |t|
      t.date        :the_date
      t.timestamps
    end

    create_table    :shopping_list_meals do |t|
      t.integer     :shopping_list_id
      t.integer     :meal_id
      t.timestamps
    end

    create_table    :shopping_list_recipes do |t|
      t.integer     :shopping_list_id
      t.integer     :recipe_id
      t.timestamps
    end

    create_table    :shopping_list_ingredients do |t|
      t.integer     :shopping_list_id
      t.integer     :ingredient_id
      t.integer     :unit_id
      t.decimal     :quantity, precision: 8, scale: 2
      t.timestamps
    end
  end
end

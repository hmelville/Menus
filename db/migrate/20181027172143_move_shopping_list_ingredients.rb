class MoveShoppingListIngredients < ActiveRecord::Migration
  def change
    add_column :collection_ingredients, :deleted_at, :datetime

    insert_qry = %Q(
      INSERT INTO collection_ingredients (target_type, target_id, ingredient_id, unit_id, quantity, created_at)
      SELECT 'ShoppingList', shopping_list_id, ingredient_id, unit_id, quantity, created_at
      FROM shopping_list_ingredients
    )

    ActiveRecord::Base.connection.update_sql(insert_qry)

    drop_table :shopping_list_ingredients
    drop_table :recipe_ingredients
    drop_table :meal_ingredients
    drop_table :meal_recipes
  end
end

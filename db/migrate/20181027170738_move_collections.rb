class MoveCollections < ActiveRecord::Migration
  def change

    add_column :collection_ingredients, :target_type, :string, after: :id
    add_column :collection_ingredients, :target_id, :int, after: :target_type

    add_column :collection_recipes, :target_type, :string, after: :id
    add_column :collection_recipes, :target_id, :int, after: :target_type

    add_column :collection_meals, :target_type, :string, after: :id
    add_column :collection_meals, :target_id, :int, after: :target_type

    update_qry = %Q(
      UPDATE collection_ingredients, collections
      SET collection_ingredients.target_type = collections.target_type,
        collection_ingredients.target_id = collections.target_id
      WHERE collection_ingredients.collection_id = collections.id
    )

    ActiveRecord::Base.connection.update_sql(update_qry)

    update_qry = %Q(
      UPDATE collection_recipes, collections
      SET collection_recipes.target_type = collections.target_type,
        collection_recipes.target_id = collections.target_id
      WHERE collection_recipes.collection_id = collections.id
    )

    ActiveRecord::Base.connection.update_sql(update_qry)

    update_qry = %Q(
      UPDATE collection_meals, collections
      SET collection_meals.target_type = collections.target_type,
        collection_meals.target_id = collections.target_id
      WHERE collection_meals.collection_id = collections.id
    )

    ActiveRecord::Base.connection.update_sql(update_qry)

    remove_column :collection_ingredients, :collection_id
    remove_column :collection_recipes, :collection_id
    remove_column :collection_meals , :collection_id

    drop_table :collections

  end
end

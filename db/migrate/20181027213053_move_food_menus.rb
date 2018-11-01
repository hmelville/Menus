class MoveFoodMenus < ActiveRecord::Migration
  def change

    ['collection_ingredients', 'collection_recipes', 'collection_meals'].each do |table|

      update_qry = %Q(
        UPDATE #{table}
        SET target_type = REPLACE(target_type, '', '')
        WHERE target_type IS NOT NULL
      )

      ActiveRecord::Base.connection.update_sql(update_qry)
    end
  end
end

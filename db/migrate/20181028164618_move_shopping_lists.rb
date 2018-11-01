class MoveShoppingLists < ActiveRecord::Migration
  def change
    add_column :shopping_list_days, :user_id, :integer

    update_qry = %Q(
      UPDATE shopping_list_days, shopping_lists
      SET shopping_list_days.user_id = shopping_lists.user_id
      WHERE shopping_list_days.shopping_list_id = shopping_lists.id
    )

    ActiveRecord::Base.connection.update_sql(update_qry)

    remove_column :shopping_lists, :start_date
    remove_column :shopping_lists, :end_date

  end
end

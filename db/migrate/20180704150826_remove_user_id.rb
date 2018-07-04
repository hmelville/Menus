class RemoveUserId < ActiveRecord::Migration
  def change
    remove_column :shopping_list_days, :user_id
    remove_column :shopping_lists, :the_date
  end
end

class AddUserIds < ActiveRecord::Migration
  def change

    add_column :meals, :user_id, :integer
    add_column :recipes, :user_id, :integer
    add_column :ingredients, :user_id, :integer
    add_column :suppliers, :user_id, :integer
    add_column :menu_rotations, :user_id, :integer
    add_column :settings, :user_id, :integer
    add_column :shopping_list_days, :user_id, :integer
    add_column :shopping_lists, :user_id, :integer

  end
end

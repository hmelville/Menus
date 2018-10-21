class AddUserColumns < ActiveRecord::Migration
  def change
    add_column :users, :use_menus, :boolean
    add_column :users, :use_budgets, :boolean

    User.all.update_all(use_menus: true, use_budgets: true)
  end
end

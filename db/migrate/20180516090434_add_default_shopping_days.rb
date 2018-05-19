class AddDefaultShoppingDays < ActiveRecord::Migration
  def change
    add_column :settings, :default_shopping_days, :integer
  end
end

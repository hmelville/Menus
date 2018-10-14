class AddCurrencySymbol < ActiveRecord::Migration
  def change
    add_column :accounts, :group, :string
    add_column :accounts, :currency, :string
    add_column :accounts, :sort_order, :integer
  end
end

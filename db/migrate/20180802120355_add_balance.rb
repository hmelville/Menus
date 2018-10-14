class AddBalance < ActiveRecord::Migration
  def change
    add_column :transactions, :balance, :decimal, precision: 8, scale: 2
    add_column :transactions, :sort_order, :integer
    remove_column :transactions, :process_date, :date
  end
end

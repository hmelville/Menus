class ChangeTransactionType < ActiveRecord::Migration
  def change
    add_column :transactions, :transaction_type, :integer
    add_column :transactions, :particulars, :string
    remove_column :transactions, :type, :string
    remove_column :transactions, :particaulars, :string
  end
end

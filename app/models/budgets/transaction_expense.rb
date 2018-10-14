module Budgets
  class TransactionExpense < ::ApplicationBase

    # belongs_to :transaction
    # belongs_to :expense
    # belongs_to :account, through: :transaction

    validates_presence_of :transaction_id, :expense_id

    # default_scope { joins(:expense).order(expenses: :name) }

  end
end
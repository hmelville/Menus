module Budgets
  class Expense < ::ApplicationBase

    belongs_to :account
    has_many :transaction_expenses, dependent: :destroy

    default_scope { order(:name) }

  end
end
module Budgets
  class Payment < ::ApplicationBase

    belongs_to :account
    default_scope { order(:name) }

  end
end
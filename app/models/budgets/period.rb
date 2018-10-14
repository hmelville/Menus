module Budgets
  class Period < ::ApplicationBase

    default_scope { order(:sort_order) }

  end
end
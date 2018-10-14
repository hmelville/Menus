module Budgets
  class Transaction < ::ApplicationBase
    TYPES = [["Debit", 2], ["Credit", 1]]

    before_save :calulate
    after_save :recalculate, on: :update
    before_destroy :recalculate_before_destroy

    belongs_to :account
    has_many :transaction_expenses, dependent: :destroy

    validate :check_transaction_date

    validates_presence_of :account_id, :transaction_date, :transaction_type, :amount

    default_scope { order(:sort_order) }

    def check_transaction_date
      return if is_opening?
      first_tran = account.transactions.first
      if transaction_date < first_tran.transaction_date
        errors.add(:transaction_date, "Transaction date cannot be less than the account start date.")
      end
    end

    def is_opening?
      sort_order == 1
    end

    def import(file)
      data = Import.get_data_from_file(file.name, ",")
    end

    def total_expensed
      transaction_expenses.all.sum(:amount)
    end

    def expensed_klass
      total_expensed == amount ? "balance_green" : "balance_red"
    end

    def expensed_icon
      total_expensed == amount ? "check" : "times"
    end

    def calulate
      if self.is_opening?
        self.balance = (transaction_type == 1 ? amount : -amount)
      else
        current_sort_order = self.sort_order
        previous_t = previous_transaction

        if new_record? || transaction_date_changed?
          previous_sort_order = previous_t.try(:sort_order) || 0

          if new_record?
            new_sort_order = previous_sort_order + 1
            account.transactions.where("sort_order >= ?", new_sort_order).update_all("sort_order = sort_order + 1")

          elsif transaction_date_changed?

            if transaction_date < transaction_date_was
              new_sort_order = previous_sort_order + 1
              account.transactions.where("sort_order >= ? AND sort_order < ?", new_sort_order, current_sort_order).update_all("sort_order = sort_order + 1")

            elsif transaction_date > transaction_date_was
              new_sort_order = previous_sort_order
              account.transactions.where("sort_order > ? AND sort_order <= ?", current_sort_order, new_sort_order).update_all("sort_order = sort_order - 1")
            end
          end
          self.sort_order = new_sort_order
        end

        previous_balance = previous_t.try(:balance) || 0
        self.balance = previous_balance + (transaction_type == 1 ? amount : -amount)
      end
    end

    def recalculate
      next_transaction.try(:save)
    end

    def recalculate_before_destroy
      account.transactions.where("sort_order > ?", self.sort_order).update_all("sort_order = sort_order - 1")
      previous_transaction.try(:save)
    end

    def previous_transaction
      if new_record? || transaction_date_changed?
        account.transactions.where('transaction_date <= ?', transaction_date).last
      else
        account.transactions.where('sort_order < ?', sort_order).last
      end
    end

    def next_transaction
      return if new_record?
      account.transactions.where('sort_order > ?', sort_order).first
    end

  end
end
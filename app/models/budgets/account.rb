module Budgets
  class Account < ::ApplicationBase

    before_save :check_changed

    belongs_to :user
    has_many :expenses, dependent: :destroy
    accepts_nested_attributes_for :expenses, allow_destroy: true

    has_many :payments, dependent: :destroy
    accepts_nested_attributes_for :payments, allow_destroy: true

    has_many :transactions, dependent: :destroy
    accepts_nested_attributes_for :transactions, allow_destroy: true

    validate :check_start_date

    validates_presence_of :name, :group, :start_date, :opening_balance, :currency, :sort_order

    default_scope { where(active: true).order(:group, :sort_order, :name) }

    def check_changed
      return if new_record?
      if opening_balance_changed? || start_date_changed?
        if opening_balance >= 0
          transaction_type = 1
          amount = opening_balance
        else
          transaction_type = 2
          amount = -opening_balance
        end

        first_tran = transactions.first
        first_tran.transaction_date = start_date
        first_tran.transaction_type = transaction_type
        first_tran.amount = amount
        first_tran.save
      end
    end

    def check_start_date
      first_tran = transactions.first
      if transactions.where("transaction_date < ? AND id <> ?", start_date, first_tran.id).any?
        errors.add(:start_date, "Account start date cannot be greater than any of the transactions.")
      end
    end

    def current_balance
      transactions.last.balance || 0
    end

    def transactions_by_date(start_date, end_date)
      transactions.where("transaction_date BETWEEN ? AND ?", start_date, end_date)
    end

    def self.permitted_attributes
      super + [
        {
          espenses_attributes: [Budgets::Expense.permitted_attributes],
          paymentss_attributes: [Budgets::Payment.permitted_attributes],
          transactions_attributes: [Budgets::Transaction.permitted_attributes]
        }
      ]
    end
  end
end
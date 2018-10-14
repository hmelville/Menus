class AddBudgets < ActiveRecord::Migration
  def change

    create_table :periods, force: true do |t|
      t.string    :name
      t.string    :abbreviation
      t.decimal   :multiplier, precision: 8, scale: 2
      t.integer   :sort_order
      t.timestamps
    end

    Budgets::Period.new(name: "Daily", abbreviation: "Dly", multiplier: 1, sort_order: 1).save
    Budgets::Period.new(name: "Weekly", abbreviation: "Wkly", multiplier: (365.0/52), sort_order: 2).save
    Budgets::Period.new(name: "Fortnightly", abbreviation: "Fortn", multiplier: (365.0/26), sort_order: 3).save
    Budgets::Period.new(name: "Monthly", abbreviation: "Mthly", multiplier: (365.0/12), sort_order: 4).save
    Budgets::Period.new(name: "3 Monthly", abbreviation: "3 Mthly", multiplier: (365.0/4), sort_order: 5).save
    Budgets::Period.new(name: "4 Monthly", abbreviation: "4 Mthly", multiplier: (365.0/3), sort_order: 6).save
    Budgets::Period.new(name: "6 Monthly", abbreviation: "6 Mthly", multiplier: (365.0/2), sort_order: 7).save
    Budgets::Period.new(name: "Yearly", abbreviation: "Yrly", multiplier: (365), sort_order: 8).save

    create_table :accounts, force: true do |t|
      t.string    :name
      t.date      :start_date
      t.decimal   :opening_balance, precision: 8, scale: 2
      t.boolean   :active
      t.integer   :user_id
      t.timestamps
    end

    create_table :expenses, force: true do |t|
      t.integer   :account_id
      t.string    :name
      t.date      :start_date
      t.decimal   :amount, precision: 8, scale: 2
      t.integer   :parent_id
      t.boolean   :active
      t.timestamps
    end

    create_table :transactions, force: true do |t|
      t.integer   :account_id
      t.date      :transaction_date
      t.date      :process_date
      t.string    :particaulars
      t.string    :details
      t.string    :type
      t.date      :import_date
      t.decimal   :amount, precision: 8, scale: 2
      t.timestamps
    end

    create_table :transaction_expenses, force: true do |t|
      t.integer   :transaction_id
      t.integer   :expense_id
      t.decimal   :amount, precision: 8, scale: 2
      t.timestamps
    end

    create_table :payments, force: true do |t|
      t.integer   :account_id
      t.string    :name
      t.integer   :period_id
      t.decimal   :amount, precision: 8, scale: 2
      t.boolean   :is_main
      t.timestamps
    end

  end
end

class CreateDatabase < ActiveRecord::Migration
  def change
    create_table "accounts", force: true do |t|
      t.string  :name
      t.date    :start_date
      t.decimal :opening_balance, precision: 8, scale: 2
      t.boolean :active
      t.integer :user_id
      t.string  :group
      t.string  :currency
      t.integer :sort_order
      t.timestamps null: true
    end

    create_table "collection_ingredients", force: true do |t|
      t.string   :target_type
      t.integer  :target_id
      t.integer  :ingredient_id
      t.integer  :unit_id
      t.decimal  :quantity, precision: 8, scale: 2
      t.datetime :deleted_at
      t.timestamps null: true
    end

    create_table "collection_meals", force: true do |t|
      t.string  :target_type
      t.integer :target_id
      t.integer :meal_id
      t.timestamps null: true
    end

    create_table "collection_recipes", force: true do |t|
      t.string  :target_type
      t.integer :target_id
      t.integer :recipe_id
      t.timestamps null: true
    end

    create_table :delayed_jobs, force: true do |t|
      t.integer  :priority,   default: 0, null: false
      t.integer  :attempts,   default: 0, null: false
      t.text     :handler,    limit: (16.megabytes - 1), null: false
      t.text     :last_error, limit: (16.megabytes - 1)
      t.datetime :run_at
      t.datetime :locked_at
      t.datetime :failed_at
      t.string   :locked_by
      t.string   :queue
      t.timestamps null: true
    end

    add_index :delayed_jobs, [:priority, :run_at], name: "delayed_jobs_priority"

    create_table "expenses", force: true do |t|
      t.integer :account_id
      t.string  :name
      t.date    :start_date
      t.decimal :amount, precision: 8, scale: 2
      t.integer :parent_id
      t.boolean :active
      t.timestamps null: true
    end

    create_table "ingredient_suppliers", force: true do |t|
      t.integer :ingredient_id
      t.integer :supplier_id
      t.decimal :price, precision: 10, scale: 2
      t.integer :aisle
      t.timestamps null: true
    end

    create_table "ingredients", force: true do |t|
      t.string  :name
      t.integer :user_id
      t.integer :unit_id
      t.timestamps null: true
    end

    create_table "meals", force: true do |t|
      t.string  :name
      t.integer :user_id
      t.timestamps null: true
    end

    create_table :menu_items, force: true do |t|
      t.string  :name
      t.string  :url
      t.string  :icon
      t.string  :method
      t.string  :classes
      t.integer :position
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.timestamps null: true
    end

    create_table "menu_rotations", force: true do |t|
      t.integer :week
      t.integer :day
      t.integer :user_id
      t.timestamps null: true
    end

    create_table "payments", force: true do |t|
      t.integer :account_id
      t.string  :name
      t.integer :period_id
      t.decimal :amount, precision: 8, scale: 2
      t.boolean :is_main
      t.timestamps null: true
    end

    create_table :periods, force: true do |t|
      t.string  :name
      t.string  :abbreviation
      t.decimal :multiplier, precision: 8, scale: 2
      t.integer :sort_order
      t.timestamps null: true
    end

    create_table "recipes", force: true do |t|
      t.string  :name
      t.integer :user_id
      t.timestamps null: true
    end

    create_table "sessions", force: true do |t|
      t.string :session_id
      t.text   :data
      t.timestamps null: true
    end

    create_table "shopping_list_days", force: true do |t|
      t.integer :shopping_list_id
      t.date    :the_date
      t.integer :user_id
      t.timestamps null: true
    end

    create_table "shopping_lists", force: true do |t|
      t.integer :user_id
      t.timestamps null: true
    end

    create_table "suppliers", force: true do |t|
      t.string  :name
      t.integer :user_id
      t.timestamps null: true
    end

    create_table "transaction_expenses", force: true do |t|
      t.integer :transaction_id
      t.integer :expense_id
      t.decimal :amount, precision: 8, scale: 2
      t.timestamps null: true
    end

    create_table "transactions", force: true do |t|
      t.integer :account_id
      t.date    :transaction_date
      t.string  :details
      t.date    :import_date
      t.decimal :amount, precision: 8, scale: 2
      t.integer :transaction_type
      t.string  :particulars
      t.decimal :balance, precision: 8, scale: 2
      t.integer :sort_order
      t.timestamps null: true
    end

    create_table "units", force: true do |t|
      t.string  :name
      t.string  :abbreviation
      t.string  :kind
      t.decimal :conversion_rate, precision: 10, scale: 2
      t.timestamps null: true
    end

    create_table "users", force: true do |t|
      t.string   :email
      t.string   :first_name
      t.string   :last_name
      t.string   :password_digest
      t.string   :old_password_digest
      t.string   :created_by_ip
      t.string   :last_login_ip_address
      t.string   :password_token
      t.datetime :password_recovery_sent_at
      t.datetime :password_token_expires
      t.datetime :last_login_datetime
      t.boolean  :account_closed
      t.decimal  :balance, precision: 8, scale: 2
      t.integer  :menu_rotation_weeks
      t.boolean  :reminder_emails
      t.time     :reminder_emails_send_time
      t.date     :menu_rotation_start_date
      t.integer  :default_shopping_days
      t.boolean  :use_menus
      t.boolean  :use_budgets
      t.timestamps null: true
    end
  end
end
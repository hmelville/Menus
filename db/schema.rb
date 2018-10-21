# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181019203621) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.date     "start_date"
    t.decimal  "opening_balance", precision: 8, scale: 2
    t.boolean  "active"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "group"
    t.string   "currency"
    t.integer  "sort_order"
  end

  create_table "collection_ingredients", force: true do |t|
    t.integer  "collection_id"
    t.integer  "ingredient_id"
    t.integer  "unit_id"
    t.decimal  "quantity",      precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collection_meals", force: true do |t|
    t.integer  "collection_id"
    t.integer  "meal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collection_recipes", force: true do |t|
    t.integer  "collection_id"
    t.integer  "recipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collections", force: true do |t|
    t.string   "target_type"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",                    default: 0, null: false
    t.integer  "attempts",                    default: 0, null: false
    t.text     "handler",    limit: 16777215,             null: false
    t.text     "last_error", limit: 16777215
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "expenses", force: true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.date     "start_date"
    t.decimal  "amount",     precision: 8, scale: 2
    t.integer  "parent_id"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredient_suppliers", force: true do |t|
    t.integer  "ingredient_id"
    t.integer  "supplier_id"
    t.decimal  "price",         precision: 10, scale: 2
    t.integer  "aisle"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredients", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "unit_id"
  end

  create_table "meal_ingredients", force: true do |t|
    t.integer  "meal_id"
    t.integer  "ingredient_id"
    t.integer  "unit_id"
    t.decimal  "quantity",      precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meal_recipes", force: true do |t|
    t.integer  "meal_id"
    t.integer  "recipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meals", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "menu_items", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "icon"
    t.string   "method"
    t.string   "classes"
    t.integer  "position"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_rotations", force: true do |t|
    t.integer  "week"
    t.integer  "day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "payments", force: true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.integer  "period_id"
    t.decimal  "amount",     precision: 8, scale: 2
    t.boolean  "is_main"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "periods", force: true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.decimal  "multiplier",   precision: 8, scale: 2
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipe_ingredients", force: true do |t|
    t.integer  "recipe_id"
    t.integer  "ingredient_id"
    t.decimal  "quantity",      precision: 8, scale: 2
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shopping_list_days", force: true do |t|
    t.integer  "shopping_list_id"
    t.date     "the_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shopping_list_ingredients", force: true do |t|
    t.integer  "shopping_list_id"
    t.integer  "ingredient_id"
    t.integer  "unit_id"
    t.decimal  "quantity",         precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shopping_lists", force: true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "suppliers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "transaction_expenses", force: true do |t|
    t.integer  "transaction_id"
    t.integer  "expense_id"
    t.decimal  "amount",         precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.integer  "account_id"
    t.date     "transaction_date"
    t.string   "details"
    t.date     "import_date"
    t.decimal  "amount",           precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "transaction_type"
    t.string   "particulars"
    t.decimal  "balance",          precision: 8, scale: 2
    t.integer  "sort_order"
  end

  create_table "units", force: true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.string   "kind"
    t.decimal  "conversion_rate", precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_digest"
    t.string   "old_password_digest"
    t.string   "created_by_ip"
    t.string   "last_login_ip_address"
    t.string   "password_token"
    t.datetime "password_recovery_sent_at"
    t.datetime "password_token_expires"
    t.datetime "last_login_datetime"
    t.boolean  "account_closed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "balance",                   precision: 8, scale: 2
    t.integer  "menu_rotation_weeks"
    t.boolean  "reminder_emails"
    t.time     "reminder_emails_send_time"
    t.date     "menu_rotation_start_date"
    t.integer  "default_shopping_days"
    t.boolean  "use_menus"
    t.boolean  "use_budgets"
  end

end

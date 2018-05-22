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

ActiveRecord::Schema.define(version: 20171103101325) do

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
  end

  create_table "menu_rotations", force: true do |t|
    t.integer  "week"
    t.integer  "day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.integer  "menu_rotation_weeks"
    t.boolean  "reminder_emails"
    t.time     "reminder_emails_send_time"
    t.date     "menu_rotation_start_date"
    t.integer  "default_shopping_days"
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
    t.date     "the_date"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suppliers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", force: true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.string   "kind"
    t.decimal  "conversion_rate", precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

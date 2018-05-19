class CreateDatabase < ActiveRecord::Migration
  def change

    create_table "collection_ingredients", force: true do |t|
      t.integer  "collection_id"
      t.integer  "ingredient_id"
      t.integer  "unit_id"
      t.decimal  "quantity",      precision: 8, scale: 2
      t.timestamps
    end

    create_table "collection_meals", force: true do |t|
      t.integer  "collection_id"
      t.integer  "meal_id"
      t.timestamps
    end

    create_table "collection_recipes", force: true do |t|
      t.integer  "collection_id"
      t.integer  "recipe_id"
      t.timestamps
    end

    create_table "collections", force: true do |t|
      t.string   "target_type"
      t.integer  "target_id"
      t.timestamps
    end

    create_table "ingredient_suppliers", force: true do |t|
      t.integer  "ingredient_id"
      t.integer  "supplier_id"
      t.decimal  "price",         precision: 10, scale: 2
      t.integer  "aisle"
      t.timestamps
    end

    create_table "ingredients", force: true do |t|
      t.string   "name"
      t.timestamps
    end

    create_table "meal_ingredients", force: true do |t|
      t.integer  "meal_id"
      t.integer  "ingredient_id"
      t.integer  "unit_id"
      t.decimal  "quantity",      precision: 8, scale: 2
      t.timestamps
    end

    create_table "meal_recipes", force: true do |t|
      t.integer  "meal_id"
      t.integer  "recipe_id"
      t.timestamps
    end

    create_table "meals", force: true do |t|
      t.string   "name"
      t.timestamps
    end

    create_table "menu_rotations", force: true do |t|
      t.integer  "week"
      t.integer  "day"
      t.timestamps
    end

    create_table "recipe_ingredients", force: true do |t|
      t.integer  "recipe_id"
      t.integer  "ingredient_id"
      t.decimal  "quantity",      precision: 8, scale: 2
      t.integer  "unit_id"
      t.timestamps
    end

    create_table "recipes", force: true do |t|
      t.string   "name"
      t.timestamps
    end

    create_table "settings", force: true do |t|
      t.integer  "menu_rotation_weeks"
      t.boolean  "reminder_emails"
      t.time     "reminder_emails_send_time"
      t.date     "menu_rotation_start_date"
      t.integer  "default_shopping_days"
      t.timestamps
    end

    create_table "shopping_list_days", force: true do |t|
      t.integer  "shopping_list_id"
      t.date     "the_date"
      t.timestamps
    end

    create_table "shopping_list_ingredients", force: true do |t|
      t.integer  "shopping_list_id"
      t.integer  "ingredient_id"
      t.integer  "unit_id"
      t.decimal  "quantity",         precision: 8, scale: 2
      t.timestamps
    end

    create_table "shopping_lists", force: true do |t|
      t.date     "the_date"
      t.date     "start_date"
      t.date     "end_date"
      t.timestamps
    end

    create_table "suppliers", force: true do |t|
      t.string   "name"
      t.timestamps
    end

    create_table "units", force: true do |t|
      t.string   "name"
      t.string   "abbreviation"
      t.string   "kind"
      t.decimal  "conversion_rate", precision: 10, scale: 2
      t.timestamps
    end


  end
end

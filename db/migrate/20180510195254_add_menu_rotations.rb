class AddMenuRotations < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.string       :name
      t.timestamps
    end

    create_table :meal_recipes do |t|
      t.integer      :meal_id
      t.integer      :recipe_id
      t.timestamps
    end

    create_table :menu_rotations do |t|
      t.integer       :week
      t.integer       :day
      t.timestamps
    end
  end
end

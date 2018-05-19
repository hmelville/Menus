class AlterQuantityColumn < ActiveRecord::Migration
  def change
    change_column :recipe_ingredients, :quantity, :decimal, precision: 8, scale: 2
  end
end

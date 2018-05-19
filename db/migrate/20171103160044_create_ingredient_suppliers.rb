class CreateIngredientSuppliers < ActiveRecord::Migration
  def change
    create_table :ingredient_suppliers do |t|
      t.integer :ingredient_id
      t.integer :supplier_id
      t.decimal :price, precision: 10, scale: 2
      t.integer :aisle
      t.timestamps
    end
  end
end

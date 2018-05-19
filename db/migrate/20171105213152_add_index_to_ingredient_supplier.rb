class AddIndexToIngredientSupplier < ActiveRecord::Migration
  def change
    #ALTER TABLE :ingredient_suppliers ADD UNIQUE "uix_ingredient_suppliers_ingredient_id_supplier_id" ( "ingredient_id", "supplier_id" );
    add_index :ingredient_suppliers, [:ingredient_id, :supplier_id], unique: true
  end
end

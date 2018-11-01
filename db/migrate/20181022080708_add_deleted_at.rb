class AddDeletedAt < ActiveRecord::Migration
  def change
    add_column :shopping_list_ingredients, :deleted_at, :datetime
  end
end

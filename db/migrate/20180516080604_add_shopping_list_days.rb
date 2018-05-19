class AddShoppingListDays < ActiveRecord::Migration
  def change

    create_table    :shopping_list_days do |t|
      t.integer     :shopping_list_id
      t.date        :the_date
      t.timestamps
    end


    add_column :shopping_lists, :start_date, :date
    add_column :shopping_lists, :end_date, :date

  end
end

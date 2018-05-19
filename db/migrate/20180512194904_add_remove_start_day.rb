class AddRemoveStartDay < ActiveRecord::Migration
  def change
    remove_column :settings, :menu_rotation_start_day
    add_column :settings, :menu_rotation_start_date, :date
  end
end

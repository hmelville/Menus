class AddMoveSettings < ActiveRecord::Migration
  def change
    add_column :users, :balance, :decimal, precision: 8, scale: 2

    add_column :users, :menu_rotation_weeks, :integer
    add_column :users, :reminder_emails, :boolean
    add_column :users, :reminder_emails_send_time, :time
    add_column :users, :menu_rotation_start_date, :date
    add_column :users, :default_shopping_days, :integer

    update_qry = %Q(
      UPDATE users, settings
      SET users.menu_rotation_weeks = settings.menu_rotation_weeks,
        users.reminder_emails = settings.reminder_emails,
        users.reminder_emails_send_time = settings.reminder_emails_send_time,
        users.menu_rotation_start_date = settings.menu_rotation_start_date,
        users.menu_rotation_weeks = settings.menu_rotation_weeks,
        users.default_shopping_days = settings.default_shopping_days
      WHERE users.id = settings.user_id
    )

    ActiveRecord::Base.connection.update_sql(update_qry)


    drop_table :settings
  end
end

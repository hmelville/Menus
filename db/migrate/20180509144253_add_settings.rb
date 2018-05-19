class AddSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer       :menu_rotation_weeks
      t.integer       :menu_rotation_start_day
      t.boolean       :reminder_emails
      t.time          :reminder_emails_send_time
      t.timestamps
    end
  end
end

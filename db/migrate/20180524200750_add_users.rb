class AddUsers < ActiveRecord::Migration
  def change

    create_table "users", force: true do |t|
      t.string   "email"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "password_digest"
      t.string   "old_password_digest"
      t.string   "created_by_ip"
      t.string   "last_login_ip_address"
      t.string   "password_token"
      t.datetime "password_recovery_sent_at"
      t.datetime "password_token_expires"
      t.datetime "last_login_datetime"
      t.boolean  "account_closed"
      t.timestamps
    end

    create_table "sessions", force: true do |t|
      t.string   "session_id"
      t.text     "data"
      t.timestamps
    end

  end
end

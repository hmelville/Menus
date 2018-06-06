module FoodMenus
  class MenuRotation < ::ApplicationBase

    belongs_to :user
    has_one :collection, as: :target, dependent: :destroy
    after_create :create_collection

    default_scope { order(:week, :day) }

    def week_day_name
      "Week #{week} - Day #{day} - #{day_name}"
    end

    def day_of_week(num_days)
      setting = user.setting
      (setting.menu_rotation_start_date + (num_days.days)).wday
    end

    def day_name
      setting = user.setting
      (setting.menu_rotation_start_date + ((week - 1) * 7 + (day - 1)).days).strftime("%A")
    end

    def is_today?
      h = current_user.menu_rotation.get_day_week_by_date(Date.today, current_user.setting)
      h[:week] == week && h[:day] == day
    end
  end
end
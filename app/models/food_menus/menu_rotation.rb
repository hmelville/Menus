module FoodMenus
  class MenuRotation < ActiveRecord::Base

    has_one :collection, as: :target, dependent: :destroy
    after_create :create_collection

    default_scope { order(:week, :day) }

    def week_day_name
      setting = Setting.all.first
      "Week #{self.week} - Day #{self.day} - #{day_name}"
    end

    def self.day_of_week(num_days, setting)
      (setting.menu_rotation_start_date + (num_days.days)).wday
    end

    def day_name
      setting = Setting.all.first
      (setting.menu_rotation_start_date + ((self.week - 1) * 7 + (self.day - 1)).days).strftime("%A")
    end

    def is_today?
      h = MenuRotation.get_day_week_by_date(Date.today)
      h[:week] == self.week && h[:day] == self.day
    end

    def self.get_day_week_by_date(the_date)
      setting = Setting.all.first
      day_diff = (the_date - setting.menu_rotation_start_date).to_i
      week = (((day_diff / 7) + 1 )% -setting.menu_rotation_weeks) + setting.menu_rotation_weeks
      day = ((day_diff + 1) % - 7) + 7
      {week: week, day: day}
    end

    def self.get_rotation_by_date(the_date)
      h = get_day_week_by_date(the_date)
      MenuRotation.where("week = ? AND day = ?", h[:week], h[:day]).first
    end

    def self.process_menu_rotations
      setting = Setting.all.first
      # Create new ones if they don't already exist
      (1..setting.menu_rotation_weeks).each do |menu_rotation_week|
        (1..7).each do |menu_rotation_day|
          next if MenuRotation.where("week = ? AND day = ?", menu_rotation_week, menu_rotation_day).any?
          MenuRotation.create(week: menu_rotation_week, day: menu_rotation_day)
        end
      end

      # Remove ones that are no longer needed
      MenuRotation.all.each do |menu_rotation|
        menu_rotation.destroy unless (1..setting.menu_rotation_weeks).include?(menu_rotation.week)
      end
    end
  end
end
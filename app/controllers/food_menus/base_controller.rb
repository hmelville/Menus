module FoodMenus
  class BaseController < ApplicationController
    before_action :create_setting

    def create_setting
      unless current_user.setting.present?
        setting = current_user.setting.create(menu_rotation_weeks: 4, menu_rotation_start_date: Date.today, reminder_emails: false, default_shopping_days: 7)
        current_user.process_menu_rotations
        redirect_to edit_food_menus_setting_path(setting)
      end
    end
  end
end
module FoodMenus
  class BaseController < ApplicationController
    before_action :create_settings

    def create_settings
      unless FoodMenus::Setting.all.present?
        setting = FoodMenus::Setting.create(menu_rotation_weeks: 4, menu_rotation_start_date: Date.today, reminder_emails: false, default_shopping_days: 7)
        FoodMenus::MenuRotation.process_menu_rotations
        redirect_to edit_food_menus_setting_path(setting)
      end
    end
  end
end
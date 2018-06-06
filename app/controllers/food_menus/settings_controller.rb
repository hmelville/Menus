module FoodMenus
  class SettingsController < BaseController
    before_action :setup
    skip_before_action :verify_authenticity_token

    def index
      @setting_d = FoodMenus::SettingsDecorator.decorate(@setting)
    end

    def update
      if @setting.update(setting_params)
        current_user.process_menu_rotations
        flash[:notice] = "Successfully updated settings."
        redirect_to food_menus_settings_path
      else
        flash.now[:alert] = @setting.errors if @setting.errors.any?
        render :edit
      end
    end

    private
      def setup
        @setting = current_user.setting

        unless @setting
          flash[:notice] = "Can't find settings."
          redirect_to account_path
          return
        end

        case action_name
        when 'edit','update'
          @setting_page_heading = "Edit Settings"
          @setting_buttons = %i(save cancel)
        when 'index'
          @setting_page_heading = "Settings"
          @setting_buttons = %i(edit)
        end
      end

      def setting_params
        params.require(:food_menus_setting).permit(:menu_rotation_weeks, :menu_rotation_start_date, :reminder_emails, :reminder_emails_send_time, :default_shopping_days)
      end
  end
end
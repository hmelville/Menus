class SettingsController < ApplicationController
  before_action :setup
  skip_before_action :verify_authenticity_token

  def index
    @setting_d = SettingsDecorator.decorate(@setting)
  end

  def update
    if @setting.update(setting_params)
      MenuRotation.process_menu_rotations
      flash[:notice] = "Successfully updated settings."
      redirect_to settings_path
    else
      flash.now[:alert] = @setting.errors if @setting.errors.any?
      render :edit
    end
  end

  private
    def setup
      if params[:id]
        @setting = Setting.find(params[:id])
      else
        @setting = Setting.all.first
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
      params.require(:setting).permit(:menu_rotation_weeks, :menu_rotation_start_date, :reminder_emails, :reminder_emails_send_time, :default_shopping_days)
    end
end

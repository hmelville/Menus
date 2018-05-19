class MenuRotationsController < ApplicationController
  before_action :setup
  skip_before_action :verify_authenticity_token

  def show
    @menu_rotations = MenuRotation.all
  end

  def index
    @menu_rotations = MenuRotation.all
  end

  private
    def setup
      if params[:id]
        @menu_rotation ||= MenuRotation.find(params[:id])
      end

      @setting = Setting.all.first

      case action_name
      when 'show'
        @menu_rotation_page_heading = "#{@menu_rotation.week_day_name}"
        @menu_rotation_buttons = %i(index)
      end
    end

    def menu_rotations_params
      params.require(:menu_rotations).permit(:menu_rotation_id, :week, :day, :collection_id)
    end
end

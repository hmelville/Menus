module FoodMenus
  class MenuRotationsController < BaseController
    before_action :setup
    skip_before_action :verify_authenticity_token

    def show
      @menu_rotations = FoodMenus::MenuRotation.all
    end

    def index
      FoodMenus::MenuRotation.process_menu_rotations unless FoodMenus::MenuRotation.any?
      @menu_rotations = FoodMenus::MenuRotation.all
    end

    private
      def setup
        if params[:id]
          @menu_rotation ||= FoodMenus::MenuRotation.find(params[:id])
        end

        @setting = Setting.all.first

        case action_name
        when 'show'
          @menu_rotation_page_heading = "#{@menu_rotation.week_day_name}"
          @menu_rotation_buttons = %i(index)
        end
      end

      def menu_rotations_params
        params.require(:food_menus_menu_rotations).permit(:menu_rotation_id, :week, :day, :collection_id)
      end
  end
end
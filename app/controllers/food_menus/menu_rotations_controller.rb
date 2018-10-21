module FoodMenus
  class MenuRotationsController < BaseController

    load_and_authorize_resource :user, class: 'User'
    load_and_authorize_resource :menu_rotation, class: 'FoodMenus::MenuRotation'

    before_action :setup
    skip_before_action :verify_authenticity_token

    def show
    end

    def index
      current_user.process_menu_rotations unless current_user.menu_rotations.any?
      @menu_rotations = current_user.menu_rotations.all
    end

    private
      def setup
        case action_name
        when 'show'
          @menu_rotation_page_heading = "#{@menu_rotation.week_day_name}"
          @menu_rotation_buttons = %i(index)
        end
      end

      def menu_rotations_params
        params.require(:food_menus_menu_rotations).permit(FoodMenus::MenuRotation.permitted_attributes)
      end
  end
end
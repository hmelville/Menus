module FoodMenus
  class MenuRotationsController < BaseController
    before_action :setup
    skip_before_action :verify_authenticity_token

    def show
      @menu_rotations = current_user.menu_rotations.all
    end

    def index
      current_user.process_menu_rotations unless current_user.menu_rotations.any?
      @menu_rotations = current_user.menu_rotations.all
    end

    private
      def setup
        if params[:id]
          @menu_rotation = current_user.menu_rotations.find_by_id(params[:id])
          unless @menu_rotation
            flash[:notice] = "Can't find menu rotation."
            redirect_to food_menus_menu_rotations_path
            return
          end
        end
        @setting = current_user.setting

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
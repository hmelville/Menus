module FoodMenus
  class ShoppingListDaysController < BaseController
    before_action :setup
    skip_before_action :verify_authenticity_token

    def show
    end

    private
      def setup
        if params[:id]
          @shopping_list_day = current_user.shopping_list.shopping_list_days.find(params[:id])
        end

        case action_name
        when 'show'
          @shopping_list_day_page_heading = "#{@shopping_list_day.day_name}"
          @shopping_list_day_buttons = %i(index)
        end
      end
  end
end
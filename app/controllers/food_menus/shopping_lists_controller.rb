module FoodMenus
  class ShoppingListsController < BaseController

    load_and_authorize_resource :shopping_list, class: 'FoodMenus::ShoppingList'

    before_action :setup, except: [:build]
    skip_before_action :verify_authenticity_token

    def index
    end

    def update
      @shopping_list.update_attributes(shopping_list_params)
      @shopping_list.build_shopping_list_days
      redirect_to food_menus_shopping_list_path(@shopping_list)
    end

    def build_shopping_list
      @shopping_list.build_shopping_list_ingredients
      redirect_to food_menus_shopping_list_ingredients_path
    end

    private
      def setup
        @current_user = current_user

        @shopping_list = @shopping_list || FoodMenus::ShoppingList.create(user: current_user)

        @start_date = Date.today
        @end_date = @start_date + (@current_user.default_shopping_days - 1).day

        if @shopping_list.present?
          unless @shopping_list.shopping_list_days.any?
            @shopping_list.update_attributes(start_date: @start_date, end_date: @end_date)
          end
        else
          @shopping_list = FoodMenus::ShoppingList.create(start_date: @start_date, end_date: @end_date, user: current_user)
        end

        redirect_to food_menus_shopping_list_path(@shopping_list) if action_name == "index"
      end

      def shopping_list_params
        params.require(:food_menus_shopping_list).permit(FoodMenus::ShoppingList.permitted_attributes)
      end
  end
end
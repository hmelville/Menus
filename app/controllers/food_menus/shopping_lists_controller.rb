module FoodMenus
  class ShoppingListsController < BaseController
    before_action :setup, except: [:build]
    skip_before_action :verify_authenticity_token

    def index
    end

    def show
    end

    def edit
      @shopping_list = current_user.shopping_list
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
        @Setting = current_user.setting

        @shopping_list = current_user.shopping_list || FoodMenus::ShoppingList.create(user: current_user)

        @start_date = Date.today
        @end_date = @start_date + (@Setting.default_shopping_days - 1).day

        if @shopping_list.present?
          unless @shopping_list.shopping_list_days.any?
            @shopping_list.update_attributes(start_date: @start_date, end_date: @end_date)
          end
        else
          @shopping_list = FoodMenus::ShoppingList.new(start_date: @start_date, end_date: @end_date).save
        end

        redirect_to food_menus_shopping_list_path(@shopping_list) if action_name == "index"
      end

      def shopping_list_params
        params.require(:food_menus_shopping_list).permit(:start_date, :end_date, :custom_action)
      end
  end
end
module FoodMenus
  class MealsController < BaseController
    load_and_authorize_resource class: 'FoodMenus::Meal'
    before_action :setup
    skip_before_action :verify_authenticity_token

    BACK_TO_KEY = :food_menus_collection_meal_return_to

    def back_to_key
      BACK_TO_KEY
    end

    def index
    end

    def new
    end

    def create
      if @meal.save
        flash[:notice] = "Successfully created meal."
        go_back(@meal)
      else
        flash.now[:alert] = @meal.errors if @meal.errors.any?
        render :new
      end
    end

    def update
      if @meal.update_attributes(meal_params)
        flash[:notice] = "Successfully updated meal."
        go_back(food_menus_meals_path)
      else
        flash.now[:alert] = @meal.errors if @meal.errors.any?
        render :edit
      end
    end

    def destroy
      @meal.destroy
      flash[:notice] = "Successfully destroyed meal."
      go_back(food_menus_meals_path)
    end

    private
      def setup
        case action_name
        when 'new','create'
          @meal_page_heading = "New Meal"
          @meal_buttons = %i(save cancel)
        when 'edit','update'
          @meal_page_heading = "Edit Meal #{@meal.name}"
          @meal_buttons = %i(save cancel)
        when 'show'
          @meal_page_heading = "#{@meal.name}"
          @meal_buttons = %i(edit delete index)
        when 'index'
          @meal_page_heading = "Meals"
          @meal_buttons = %i(new)
        end
      end

      def meal_params
        params.require(:food_menus_meal).permit(FoodMenus::Meal.permitted_attributes)
      end

  end
end
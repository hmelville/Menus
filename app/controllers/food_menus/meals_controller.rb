module FoodMenus
  class MealsController < BaseController
    before_action :set_back, only: [:new, :edit]
    before_action :setup
    skip_before_action :verify_authenticity_token

    def index
      @meals = current_user.meals.all
    end

    def new
      @meal = FoodMenus::Meal.new()
    end

    def create
      @meal = current_user.meals.new(meal_params)
      if @meal.save
        flash[:notice] = "Successfully created meal."
        redirect_to session[:meal_return_to]
      else
        flash.now[:alert] = @meal.errors if @meal.errors.any?
        render :new
      end
    end

    def update
      if @meal.update(meal_params)
        flash[:notice] = "Successfully updated meal."
        redirect_to session[:meal_return_to]
      else
        flash.now[:alert] = @meal.errors if @meal.errors.any?
        render :edit
      end
    end

    def destroy
      @meal.destroy
      flash[:notice] = "Successfully destroyed meal."
      redirect_to food_menus_meals_path
    end

    private
      def set_back
        session[:meal_return_to] = request.referer
      end

      def setup
        if params[:id]
          @meal = current_user.meals.find_by_id(params[:id])
          unless @meal
            flash[:notice] = "Can't find meal."
            redirect_to food_menus_meals_path
            return
          end
        end

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
        params.require(:food_menus_meal).permit(:name)
      end

  end
end
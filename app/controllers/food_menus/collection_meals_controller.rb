module FoodMenus
  class CollectionMealsController < BaseController
    before_action :setup
    skip_before_action :verify_authenticity_token

    BACK_TO_KEY = :food_menus_collection_meal_return_to

    def back_to_key
      BACK_TO_KEY
    end

    def new
      @collection_meal = FoodMenus::CollectionMeal.new(collection_id: @collection.id)
    end

    def create
      @collection_meal = FoodMenus::CollectionMeal.new(collection_meal_params)
      if @collection_meal.save
        flash[:notice] = "Successfully added meal."
        go_back
      else
        flash.now[:alert] = @collection_meal.errors if @collection_meal.errors.any?
        render :new
      end
    end

    def update
      if @collection_meal.update_attributes(collection_meal_params)
        flash[:notice] = "Successfully updated meal."
        go_back
      else
        flash.now[:alert] = @collection_meal.errors if @collection_meal.errors.any?
        render :edit
      end
    end

    def destroy
      @collection_meal.destroy
      flash[:notice] = "Successfully destroyed meal."
      go_back
    end

    private

      def setup
        if params[:id]
          @collection_meal = FoodMenus::CollectionMeal.find(params[:id])
          @collection = @collection_meal.collection
        elsif params[:collection_id]
          @collection = FoodMenus::Collection.find(params[:collection_id])
        elsif params[:food_menus_collection_meal][:collection_id]
          @collection = FoodMenus::Collection.find(params[:food_menus_collection_meal][:collection_id])
        end

        check_permission(@collection)

        case action_name
        when 'new','create'
          @collection_meal_page_heading = "New Meal"
          @collection_meal_buttons = %i(save cancel)
          @meals = current_user.meals.all
        when 'edit','update'
          @collection_meal_page_heading = "Edit Meal"
          @collection_meal_buttons = %i(save cancel delete)
          @meals = current_user.meals.all
        when 'show'
          @collection_meal_page_heading = "#{@collection_meal.meal.name}"
          @collection_meal_buttons = %i(edit delete index)
        end
      end

      def check_permission(collection)
        unless collection.target.user == current_user
          flash[:notice] = "Can't find meal."
          go_back
          return
        end
      end

      def collection_meal_params
        params.require(:food_menus_collection_meal).permit(FoodMenus::CollectionMeal.permitted_attributes)
      end
  end
end

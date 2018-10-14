module FoodMenus
  class IngredientsController < BaseController
    before_action :setup
    skip_before_action :verify_authenticity_token

    BACK_TO_KEY = :food_menus_ingredient_return_to

    def back_to_key
      BACK_TO_KEY
    end

    def index
      @ingredients = current_user.ingredients.all
    end

    def new
      @ingredient = FoodMenus::Ingredient.new()
    end

    def create
      @ingredient = current_user.ingredients.new(ingredient_params)
      if @ingredient.save
        flash[:notice] = "Successfully created ingredient."
        go_back(food_menus_ingredients_path)
      else
        flash.now[:alert] = @ingredient.errors if @ingredient.errors.any?
        render :new
      end
    end

    def update
      if @ingredient.update(ingredient_params)
        flash[:notice] = "Successfully updated ingredient."
        go_back(food_menus_ingredients_path)
      else
        flash.now[:alert] = @ingredient.errors if @ingredient.errors.any?
        render :edit
      end
    end

    def destroy
      @ingredient.destroy
      flash[:notice] = "Successfully destroyed ingredient."
      go_back(food_menus_ingredients_path)
    end

    private
      def setup
        if params[:id]
          @ingredient = current_user.ingredients.find_by_id(params[:id])

          unless @ingredient
            flash[:notice] = "Can't find ingredient."
            go_back
            return
          end
        end

        case action_name
        when 'new','create'
          @ingredient_page_heading = "New Ingredient"
          @ingredient_buttons = %i(save cancel)
        when 'edit','update'
          @ingredient_page_heading = "Edit Ingredient #{@ingredient.name}"
          @ingredient_buttons = %i(save cancel)
        when 'show'
          @ingredient_page_heading = "#{@ingredient.name}"
          @ingredient_buttons = %i(edit delete index)
        when 'index'
          @ingredient_page_heading = "Ingredients"
          @ingredient_buttons = %i(new)
        end
      end

      def ingredient_params
        params.require(:food_menus_ingredient).permit(FoodMenus::Ingredient.permitted_attributes)
      end
  end
end
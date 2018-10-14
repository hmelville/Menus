module FoodMenus
  class RecipesController < BaseController
    before_action :setup
    skip_before_action :verify_authenticity_token

    BACK_TO_KEY = :food_menus_recipe_return_to

    def back_to_key
      BACK_TO_KEY
    end

    def index
      @recipes = current_user.recipes.all
    end

    def new
      @recipe = FoodMenus::Recipe.new()
    end

    def create
      @recipe = current_user.recipes.new(recipe_params)
      if @recipe.save
        flash[:notice] = "Successfully created recipe."
        go_back(@recipe)
      else
        flash.now[:alert] = @recipe.errors if @recipe.errors.any?
        render :new
      end
    end

    def update
      if @recipe.update(recipe_params)
        flash[:notice] = "Successfully updated recipe."
        go_back(food_menus_recipes_path)
      else
        flash.now[:alert] = @recipe.errors if @recipe.errors.any?
        render :edit
      end
    end

    def destroy
      @recipe.destroy
      flash[:notice] = "Successfully destroyed recipe."
      go_back(food_menus_recipes_path)
    end

    private
      def setup
        if params[:id]
          @recipe = current_user.recipes.find_by_id(params[:id])
          unless @recipe
            flash[:notice] = "Can't find recipe."
            redirect_to food_menus_recipes_path
            return
          end
        end

        case action_name
        when 'new','create'
          @recipe_page_heading = "New Recipe"
          @recipe_buttons = %i(save cancel)
        when 'edit','update'
          @recipe_page_heading = "Edit Recipe #{@recipe.name}"
          @recipe_buttons = %i(save cancel)
        when 'show'
          @recipe_page_heading = "#{@recipe.name}"
          @recipe_buttons = %i(edit delete index)
        when 'index'
          @recipe_page_heading = "Recipes"
          @recipe_buttons = %i(new)
        end
      end

      def recipe_params
        params.require(:food_menus_recipe).permit(FoodMenus::Recipe.permitted_attributes)
      end

  end
end
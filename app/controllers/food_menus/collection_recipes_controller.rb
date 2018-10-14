module FoodMenus
  class CollectionRecipesController < BaseController
    before_action :setup
    skip_before_action :verify_authenticity_token

    BACK_TO_KEY = :food_menus_collection_recipe_return_to

    def back_to_key
      BACK_TO_KEY
    end

    def new
      @collection_recipe = FoodMenus::CollectionRecipe.new(collection_id: @collection.id)
    end

    def create
      @collection_recipe = FoodMenus::CollectionRecipe.new(collection_recipe_params)
      if @collection_recipe.save
        flash[:notice] = "Successfully added recipe."
        go_back
      else
        byebug
        flash.now[:alert] = @collection_recipe.errors if @collection_recipe.errors.any?
        render :new
      end
    end

    def update
      if @collection_recipe.update_attributes(collection_recipe_params)
        flash[:notice] = "Successfully updated menu."
        go_back
      else
        flash.now[:alert] = @collection_recipe.errors if @collection_recipe.errors.any?
        render :edit
      end
    end

    def destroy
      @collection_recipe.destroy
      flash[:notice] = "Successfully destroyed recipe."
      go_back
    end

    private

      def setup
        if params[:id]
          @collection_recipe = FoodMenus::CollectionRecipe.find(params[:id])
          @collection = @collection_recipe.collection
        elsif params[:collection_id]
          @collection = FoodMenus::Collection.find(params[:collection_id])
        elsif params[:food_menus_collection_recipe][:collection_id]
          @collection = FoodMenus::Collection.find(params[:food_menus_collection_recipe][:collection_id])
        end

        check_permission(@collection)

        case action_name
        when 'new','create'
          @collection_recipe_page_heading = "Add Recipe"
          @collection_recipe_buttons = %i(save cancel)
          @recipes = current_user.recipes.all
        when 'edit','update'
          @collection_recipe_page_heading = "Edit Recipe"
          @collection_recipe_buttons = %i(save cancel delete)
          @recipes = current_user.recipes.all
        when 'show'
          @collection_recipe_page_heading = "#{@collection_recipe.recipe.name}"
          @collection_recipe_buttons = %i(edit delete index)
        end
      end

      def check_permission(collection)
        unless collection.target.user == current_user
          flash[:notice] = "Can't find Recipe."
          go_back
          return
        end
      end

      def collection_recipe_params
        params.require(:food_menus_collection_recipe).permit(FoodMenus::CollectionRecipe.permitted_attributes)
      end
  end
end
module FoodMenus
  class ShoppingListIngredientsController < BaseController
    before_action :setup
    skip_before_action :verify_authenticity_token

    def index
      @shopping_list_ingredients = FoodMenus::ShoppingListIngredient.all
    end

    def new
      @shopping_list_ingredient = FoodMenus::ShoppingListIngredient.new(shopping_list_id: @shopping_list.id)
    end

    def create
      @shopping_list_ingredient = FoodMenus::ShoppingListIngredient.new(shopping_list_ingredient_params)
      if @shopping_list_ingredient.save
        flash[:notice] = "Successfully added ingredient."
        redirect_to food_menus_shopping_list_ingredients_path
      else
        flash.now[:alert] = @shopping_list_ingredient.errors if @shopping_list_ingredient.errors.any?
        render :new
      end
    end

    def add_quantity
      alter_quantity(1)
    end

    def deduct_quantity
      alter_quantity(-1)
    end

    def destroy
      @shopping_list_ingredient.destroy
      flash[:notice] = "Successfully destroyed ingredient."
      redirect_to food_menus_shopping_list_ingredients_path
    end

    private
      def setup
        @shopping_list = FoodMenus::ShoppingList.all.first

        if params[:id]
          @shopping_list_ingredient = FoodMenus::ShoppingListIngredient.find(params[:id])
        end

        case action_name
        when 'new','create'
          @shopping_list_ingredient_page_heading = "New Ingredient"
          @shopping_list_ingredient_buttons = %i(save cancel)
        when 'index'
          @shopping_list_ingredient_page_heading = "Shopping List"
          @shopping_list_ingredient_buttons = %i(new)
        end
      end

      def alter_quantity(qty)
        cur_qty = @shopping_list_ingredient.quantity
        if (cur_qty + qty) > 0
          FoodMenus::ShoppingListIngredient.update_counters(@shopping_list_ingredient, quantity: qty)
          flash[:notice] = "Successfully updated ingredient."
        else
          @shopping_list_ingredient.destroy
          flash[:notice] = "Successfully destroyed ingredient."
        end
        redirect_to food_menus_shopping_list_ingredients_path
      end

      def shopping_list_ingredient_params
        params.require(:food_menus_shopping_list_ingredient).permit(:shopping_list_id, :ingredient_id, :quantity, :unit_id)
      end
  end
end
module FoodMenus
  class IngredientSuppliersController < BaseController
    before_action :setup
    skip_before_action :verify_authenticity_token

    BACK_TO_KEY = :food_menus_collection_meal_return_to

    def back_to_key
      BACK_TO_KEY
    end

    def new
      @ingredient_supplier = FoodMenus::IngredientSupplier.new(ingredient_id: @ingredient.id)
    end

    def create
      @ingredient_supplier = FoodMenus::IngredientSupplier.new(ingredient_supplier_params)
      if @ingredient_supplier.save
        flash[:notice] = "Successfully added supplier to ingredient."
        go_back
      else
        flash.now[:alert] = @ingredient_supplier.errors if @ingredient_supplier.errors.any?
        render :new
      end
    end

    def update
      if @ingredient_supplier.update_attributes(ingredient_supplier_params)
        flash[:notice] = "Successfully updated ingredient supplier."
        go_back
      else
        flash.now[:alert] = @ingredient_supplier.errors if @ingredient_supplier.errors.any?
        render :new
      end
    end

    def destroy
      @ingredient_supplier.destroy
      flash[:notice] = "Successfully destroyed ingredient supplier."
        go_back
    end

    private
      def setup
        if params[:id]
          @ingredient_supplier = FoodMenus::IngredientSupplier.find(params[:id])
          @ingredient = @ingredient_supplier.ingredient
        elsif params[:ingredient_id]
          @ingredient = FoodMenus::Ingredient.find(params[:ingredient_id])
        elsif params[:food_menus_ingredient_supplier][:ingredient_id]
          @ingredient = FoodMenus::Ingredient.find(params[:food_menus_ingredient_supplier][:ingredient_id])
        end

        unless @ingredient.user == current_user
          flash[:notice] = "Can't find ingredient supplier."
          go_back
          return
        end

        case action_name
        when 'new','create'
          @ingredient_supplier_page_heading = "New Ingredient Supplier"
          @ingredient_supplier_buttons = %i(save cancel)
          @suppliers = current_user.suppliers.all
        when 'edit','update'
          @ingredient_supplier_page_heading = "Edit Ingredient Supplier"
          @ingredient_supplier_buttons = %i(save cancel delete)
          @suppliers = current_user.suppliers.all
        when 'show'
          @ingredient_supplier_page_heading = "#{@ingredient_supplier.supplier.name}"
          @ingredient_supplier_buttons = %i(edit delete index)
        end
      end

      def ingredient_supplier_params
        params.require(:food_menus_ingredient_supplier).permit(FoodMenus::IngredientSupplier.permitted_attributes)
      end
  end
end
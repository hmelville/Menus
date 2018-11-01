module Ingredients
  class IngredientSuppliersController < ApplicationController

    load_and_authorize_resource :ingredient, class: 'Ingredient'
    load_and_authorize_resource :ingredient_supplier, through: :ingredient, class: 'Ingredients::IngredientSupplier'

    before_action :setup

    skip_before_action :verify_authenticity_token

    def new
    end

    def create
      if @ingredient_supplier.save
        flash[:notice] = "Successfully added supplier to ingredient."
        redirect_to @ingredient
      else
        flash.now[:alert] = @ingredient_supplier.errors if @ingredient_supplier.errors.any?
        render :new
      end
    end

    def update
      if @ingredient_supplier.update_attributes(ingredient_supplier_params)
        flash[:notice] = "Successfully updated ingredient supplier."
        redirect_to @ingredient
      else
        flash.now[:alert] = @ingredient_supplier.errors if @ingredient_supplier.errors.any?
        render :new
      end
    end

    def destroy
      @ingredient_supplier.destroy
      flash[:notice] = "Successfully destroyed ingredient supplier."
      redirect_to @ingredient
    end

    private
      def setup
        case action_name
        when 'new','create'
          @ingredient_supplier_page_heading = "New Ingredient Supplier"
          @ingredient_supplier_buttons = %i(save cancel)
          @ingredient_suppliers = current_user.suppliers.all
        when 'edit','update'
          @ingredient_supplier_page_heading = "Edit Ingredient Supplier"
          @ingredient_supplier_buttons = %i(save cancel delete)
          @ingredient_suppliers = current_user.suppliers.all
        when 'show'
          @ingredient_supplier_page_heading = "#{@ingredient_supplier.supplier.name}"
          @ingredient_supplier_buttons = %i(edit delete index)
        end
      end

      def ingredient_supplier_params
        params.require(:ingredients_ingredient_supplier).permit(Ingredients::IngredientSupplier.permitted_attributes)
      end
  end
end
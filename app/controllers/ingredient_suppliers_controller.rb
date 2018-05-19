class IngredientSuppliersController < ApplicationController
  before_action :set_back, only: [:new, :edit]
  before_action :setup
  skip_before_action :verify_authenticity_token

  def new
    @ingredient = Ingredient.find(params[:ingredient_id])
    @ingredient_supplier = IngredientSupplier.new(ingredient_id: @ingredient.id)
  end

  def create
    @ingredient = Ingredient.find(params[:ingredient_supplier][:ingredient_id])
    @ingredient_supplier = IngredientSupplier.new(ingredient_supplier_params)
    if @ingredient_supplier.save
      flash[:notice] = "Successfully added supplier to ingredient."
      redirect_to session[:ingredient_supplier_return_to]
    else
      flash.now[:alert] = @ingredient_supplier.errors if @ingredient_supplier.errors.any?
      render :new
    end
  end

  def update
    if @ingredient_supplier.update_attributes(ingredient_supplier_params)
      flash[:notice] = "Successfully updated ingredient supplier."
      redirect_to session[:ingredient_supplier_return_to]
    else
      flash.now[:alert] = @ingredient_supplier.errors if @ingredient_supplier.errors.any?
      render :new
    end
  end

  def destroy
    @ingredient_supplier.destroy
    flash[:notice] = "Successfully destroyed ingredient supplier."
    redirect_to session[:ingredient_supplier_return_to]
  end

  private
    def set_back
      session[:ingredient_supplier_return_to] = request.referer
    end

    def setup
      if params[:id]
        @ingredient_supplier ||= IngredientSupplier.find(params[:id])
        @ingredient ||= @ingredient_supplier.ingredient
      elsif params[:ingredient_id]
        @ingredient = Ingredient.find(params[:ingredient_id])
      end

      case action_name
      when 'new','create'
        @ingredient_supplier_page_heading = "New Ingredient Supplier"
        @ingredient_supplier_buttons = %i(save cancel)
      when 'edit','update'
        @ingredient_supplier_page_heading = "Edit Ingredient Supplier"
        @ingredient_supplier_buttons = %i(save cancel delete)
      when 'show'
        @ingredient_supplier_page_heading = "#{@ingredient_supplier.supplier.name}"
        @ingredient_supplier_buttons = %i(edit delete index)
      end
    end

    def ingredient_supplier_params
      params.require(:ingredient_supplier).permit(:ingredient_id, :supplier_id, :price, :aisle)
    end
end

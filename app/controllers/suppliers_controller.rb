class SuppliersController < ApplicationController
  load_and_authorize_resource class: 'Supplier'
  before_action :setup
  skip_before_action :verify_authenticity_token

  BACK_TO_KEY = :recipe_return_to

  def back_to_key
    BACK_TO_KEY
  end

  def index
  end

  def new
  end

  def create
    if @supplier.save
      flash[:notice] = "Successfully created supplier."
      go_back(@supplier)
    else
      flash.now[:alert] = @supplier.errors if @supplier.errors.any?
      render :new
    end
  end

  def update
    if @supplier.update_attributes(supplier_params)
      flash[:notice] = "Successfully updated supplier."
      go_back(suppliers_path)
    else
      flash.now[:alert] = @supplier.errors if @supplier.errors.any?
      render :edit
    end
  end

  def destroy
    @supplier.destroy
    flash[:notice] = "Successfully destroyed supplier."
    go_back(suppliers_path)
  end

  private
    def setup
      case action_name
      when 'new','create'
        @page_heading = "New Supplier"
        @buttons = %i(save cancel)
      when 'edit','update'
        @page_heading = "Edit Supplier #{@supplier.name}"
        @buttons = %i(save cancel)
      when 'show'
        @page_heading = "#{@supplier.name}"
        @buttons = %i(edit delete index)
      when 'index'
        @page_heading = "Suppliers"
        @buttons = %i(new)
      end
    end

    def supplier_params
      params.require(:supplier).permit(Supplier.permitted_attributes)
    end
end
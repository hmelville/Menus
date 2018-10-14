module FoodMenus
  class SuppliersController < BaseController
    before_action :setup
    skip_before_action :verify_authenticity_token

    BACK_TO_KEY = :food_menus_recipe_return_to

    def back_to_key
      BACK_TO_KEY
    end

    def index
      @suppliers = current_user.suppliers.all
    end

    def new
      @supplier = FoodMenus::Supplier.new
    end

    def create
      @supplier = FoodMenus::Supplier.new(supplier_params)

      if @supplier.save
        flash[:notice] = "Successfully created supplier."
        go_back(@supplier)
      else
        flash.now[:alert] = @supplier.errors if @supplier.errors.any?
        render :new
      end
    end

    def update
      if @supplier.update(supplier_params)
        flash[:notice] = "Successfully updated supplier."
        go_back(food_menus_suppliers_path)
      else
        flash.now[:alert] = @supplier.errors if @supplier.errors.any?
        render :edit
      end
    end

    def destroy
      @supplier.destroy
      flash[:notice] = "Successfully destroyed supplier."
      go_back(food_menus_suppliers_path)
    end

    private
      def setup
        if params[:id]
          @supplier = current_user.suppliers.find(params[:id])
        end

        case action_name
        when 'new','create'
          @supplier_page_heading = "New Supplier"
          @supplier_buttons = %i(save cancel)
        when 'edit','update'
          @supplier_page_heading = "Edit Supplier #{@supplier.name}"
          @supplier_buttons = %i(save cancel)
        when 'show'
          @supplier_page_heading = "#{@supplier.name}"
          @supplier_buttons = %i(edit delete index)
        when 'index'
          @supplier_page_heading = "Suppliers"
          @supplier_buttons = %i(new)
        end
      end

      def supplier_params
        params.require(:food_menus_supplier).permit(FoodMenus::Supplier.permitted_attributes)
      end
  end
end
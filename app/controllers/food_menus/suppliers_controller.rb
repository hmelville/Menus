module FoodMenus
  class SuppliersController < BaseController
    before_action :set_back, only: [:new, :edit]
    before_action :setup
    skip_before_action :verify_authenticity_token

    def index
      @suppliers = FoodMenus::Supplier.all
    end

    def new
      @supplier = FoodMenus::Supplier.new
    end

    def create
      @supplier = FoodMenus::Supplier.new(supplier_params)

      if @supplier.save
        flash[:notice] = "Successfully created supplier."
        redirect_to session[:supplier_return_to]
      else
        flash.now[:alert] = @supplier.errors if @supplier.errors.any?
        render :new
      end
    end

    def update
      if @supplier.update(supplier_params)
        flash[:notice] = "Successfully updated supplier."
        redirect_to session[:supplier_return_to]
      else
        flash.now[:alert] = @supplier.errors if @supplier.errors.any?
        render :edit
      end
    end

    def destroy
      @supplier.destroy
      flash[:notice] = "Successfully destroyed supplier."
      redirect_to food_menus_suppliers_path
    end

    private
      def set_back
        session[:supplier_return_to] = request.referer
      end

      def setup
        if params[:id]
          @supplier = FoodMenus::Supplier.find(params[:id])
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
        params.require(:food_menus_supplier).permit(:name)
      end
  end
end
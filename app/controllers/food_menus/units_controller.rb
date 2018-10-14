module FoodMenus
  class UnitsController < BaseController
    before_action :setup
    skip_before_action :verify_authenticity_token

    def index
      @units = FoodMenus::Unit.all
    end

    def new
      @unit = FoodMenus::Unit.new
    end

    def create
      @unit = FoodMenus::Unit.new(unit_params)

      if @unit.save
        flash[:notice] = "Successfully created unit."
        redirect_to units_path
      else
        flash.now[:alert] = @unit.errors if @unit.errors.any?
        render :new
      end
    end

    def update
      if @unit.update(unit_params)
        flash[:notice] = "Successfully updated unit."
        redirect_to food_menus_units_path
      else
        flash.now[:alert] = @unit.errors if @unit.errors.any?
        render :edit
      end
    end

    def destroy
      @unit.destroy
      flash[:notice] = "Successfully destroyed unit."
      redirect_to food_menus_units_path
    end

    private
      def setup
        if params[:id]
          @unit = FoodMenus::Unit.find(params[:id])
        end

        case action_name
        when 'new','create'
          @unit_page_heading = "New Unit"
          @unit_buttons = %i(save cancel)
        when 'edit','update'
          @unit_page_heading = "Edit Unit #{@unit.name}"
          @unit_buttons = %i(save delete cancel)
        when 'index'
          @unit_page_heading = "Units"
          @unit_buttons = %i(new)
        end
      end

      def unit_params
        params.require(:food_menus_unit).permit(FoodMenus::Unit.permitted_attributes)
      end
  end
end
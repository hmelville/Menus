class UnitsController < ApplicationController
  before_action :setup
  skip_before_action :verify_authenticity_token

  def index
    @units = Unit.all
  end

  def new
    @unit = Unit.new
  end

  def create
    @unit = Unit.new(unit_params)

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
      redirect_to units_path
    else
      flash.now[:alert] = @unit.errors if @unit.errors.any?
      render :edit
    end
  end

  def destroy
    @unit.destroy
    flash[:notice] = "Successfully destroyed unit."
    redirect_to units_path
  end

  private
    def setup
      if params[:id]
        @unit = Unit.find(params[:id])
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
      params.require(:unit).permit(:name, :abbreviation, :kind, :conversion_rate, :default_unit)
    end
end

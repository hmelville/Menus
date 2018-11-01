class MealsController < ApplicationController

  load_and_authorize_resource :meal, class: 'Meal'

  before_action :setup
  skip_before_action :verify_authenticity_token

  BACK_TO_KEY = :collection_meal_return_to

  def back_to_key
    BACK_TO_KEY
  end

  def index
  end

  def new
  end

  def create
    if @meal.save
      flash[:notice] = "Successfully created meal."
      go_back(@meal)
    else
      flash.now[:alert] = @meal.errors if @meal.errors.any?
      render :new
    end
  end

  def update
    if @meal.update_attributes(meal_params)
      flash[:notice] = "Successfully updated meal."
      go_back(meals_path)
    else
      flash.now[:alert] = @meal.errors if @meal.errors.any?
      render :edit
    end
  end

  def destroy
    @meal.destroy
    flash[:notice] = "Successfully destroyed meal."
    go_back(meals_path)
  end

  private
    def setup
      case action_name
      when 'new','create'
        @page_heading = "New Meal"
        @buttons = %i(save cancel)
      when 'edit','update'
        @page_heading = "Edit Meal #{@meal.name}"
        @buttons = %i(save cancel)
      when 'show'
        @page_heading = "#{@meal.name}"
        @buttons = %i(edit delete index)
      when 'index'
        @page_heading = "Meals"
        @buttons = %i(new)
      end
    end

    def meal_params
      params.require(:meal).permit(Meal.permitted_attributes)
    end

end
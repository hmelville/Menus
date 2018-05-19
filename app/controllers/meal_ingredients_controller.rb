class MealIngredientsController < ApplicationController
  before_action :set_back, only: [:new, :edit]
  before_action :setup
  skip_before_action :verify_authenticity_token

  def new
    @meal = Meal.find(params[:meal_id])
    @meal_ingredient = MealIngredient.new(meal_id: @meal.id)
  end

  def create
    @meal = Meal.find(params[:meal_ingredient][:meal_id])
    @meal_ingredient = MealIngredient.new(meal_ingredient_params)
    if @meal_ingredient.save
      flash[:notice] = "Successfully added ingredient to meal."
      redirect_to session[:meal_ingredient_return_to]
    else
      flash.now[:alert] = @meal_ingredient.errors if @meal_ingredient.errors.any?
      render :new
    end
  end

  def update
    if @meal_ingredient.update_attributes(meal_ingredient_params)
      flash[:notice] = "Successfully updated meal ingredient."
      redirect_to session[:meal_ingredient_return_to]
    else
      flash.now[:alert] = @meal_ingredient.errors if @meal_ingredient.errors.any?
      render :edit
    end
  end

  def destroy
    @meal_ingredient.destroy
    flash[:notice] = "Successfully destroyed ingredient."
    redirect_to session[:meal_ingredient_return_to]
  end

  private
    def set_back
      session[:meal_ingredient_return_to] = request.referer
    end

    def setup
      if params[:id]
        @meal_ingredient ||= MealIngredient.find(params[:id])
        @meal ||= @meal_ingredient.meal
      elsif params[:meal_id]
        @meal = Meal.find(params[:meal_id])
      end

      case action_name
      when 'new','create'
        @meal_ingredient_page_heading = "New Meal Ingredient"
        @meal_ingredient_buttons = %i(save cancel)
      when 'edit','update'
        @meal_ingredient_page_heading = "Edit Meal Ingredient"
        @meal_ingredient_buttons = %i(save cancel delete)
      when 'show'
        @meal_ingredient_page_heading = "#{@meal_ingredient.ingredient.name}"
        @meal_ingredient_buttons = %i(edit delete index)
      end
    end

    def meal_ingredient_params
      params.require(:meal_ingredient).permit(:meal_id, :ingredient_id, :quantity, :unit_id)
    end
end

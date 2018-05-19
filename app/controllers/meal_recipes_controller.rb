class MealRecipesController < ApplicationController
  before_action :set_back, only: [:new, :edit]
  before_action :setup
  skip_before_action :verify_authenticity_token

  def new
    @meal = Meal.find(params[:meal_id])
    @meal_recipe = MealRecipe.new(meal_id: @meal.id)
  end

  def create
    @meal = Meal.find(params[:meal_recipe][:meal_id])
    @meal_recipe = MealRecipe.new(meal_recipe_params)
    if @meal_recipe.save
      flash[:notice] = "Successfully added recipe to meal."
      redirect_to session[:meal_recipe_return_to]
    else
      flash.now[:alert] = @meal_recipe.errors if @meal_recipe.errors.any?
      @recipes = Recipe.all
      render :new
    end
  end

  def update
    if @meal_recipe.update_attributes(meal_recipe_params)
      flash[:notice] = "Successfully updated meal recipe."
      redirect_to session[:meal_recipe_return_to]
    else
      flash.now[:alert] = @meal_recipe.errors if @meal_recipe.errors.any?
      @recipes = Recipe.all
      render :edit
    end
  end

  def destroy
    @meal_recipe.destroy
    flash[:notice] = "Successfully destroyed recipe."
    redirect_to @meal_recipe.meal
  end

  private
    def set_back
      session[:meal_recipe_return_to] = request.referer
    end

    def setup
      if params[:id]
        @meal_recipe ||= MealRecipe.find(params[:id])
        @meal ||= @meal_recipe.recipe
      elsif params[:meal_id]
        @meal = Meal.find(params[:meal_id])
      end

      case action_name
      when 'new','create'
        @meal_recipe_page_heading = "New Meal Recipe"
        @meal_recipe_buttons = %i(save cancel)
      when 'edit','update'
        @meal_recipe_page_heading = "Edit Meal Recipe"
        @meal_recipe_buttons = %i(save cancel delete)
      when 'show'
        @meal_recipe_page_heading = "#{@meal_recipe.recipe.name}"
        @meal_recipe_buttons = %i(edit delete index)
      end
    end

    def meal_recipe_params
      params.require(:meal_recipe).permit(:meal_id, :recipe_id)
    end
end

class RecipeIngredientsController < ApplicationController
  before_action :set_back, only: [:edit]
  before_action :setup
  skip_before_action :verify_authenticity_token

  def new
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_ingredient = RecipeIngredient.new(recipe_id: @recipe.id)
  end

  def create
    @recipe = Recipe.find(params[:recipe_ingredient][:recipe_id])
    @recipe_ingredient = RecipeIngredient.new(recipe_ingredient_params)
    if @recipe_ingredient.save
      flash[:notice] = "Successfully added ingredient to recipe."
      redirect_to session[:recipe_ingredient_return_to]
    else
      flash.now[:alert] = @recipe_ingredient.errors if @recipe_ingredient.errors.any?
      render :new
    end
  end

  def update
    if @recipe_ingredient.update_attributes(recipe_ingredient_params)
      flash[:notice] = "Successfully updated recipe ingredient."
      redirect_to session[:recipe_ingredient_return_to]
    else
      flash.now[:alert] = @recipe_ingredient.errors if @recipe_ingredient.errors.any?
      render :edit
    end
  end

  def destroy
    @recipe_ingredient.destroy
    flash[:notice] = "Successfully destroyed ingredient."
    redirect_to @recipe_ingredient.recipe
  end

  private
    def set_back
      session[:recipe_ingredient_return_to] = request.referer
    end

    def setup
      if params[:id]
        @recipe_ingredient ||= RecipeIngredient.find(params[:id])
        @recipe ||= @recipe_ingredient.recipe
      elsif params[:recipe_id]
        @recipe = Recipe.find(params[:recipe_id])
      end

      case action_name
      when 'new','create'
        @recipe_ingredient_page_heading = "New Recipe Ingredient"
        @recipe_ingredient_buttons = %i(save cancel)
      when 'edit','update'
        @recipe_ingredient_page_heading = "Edit Recipe Ingredient"
        @recipe_ingredient_buttons = %i(save cancel delete)
      when 'show'
        @recipe_ingredient_page_heading = "#{@recipe_ingredient.ingredient.name}"
        @recipe_ingredient_buttons = %i(edit delete index)
      end
    end

    def recipe_ingredient_params
      params.require(:recipe_ingredient).permit(:recipe_id, :ingredient_id, :quantity, :unit_id)
    end
end

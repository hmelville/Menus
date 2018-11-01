class RecipesController < ApplicationController
  load_and_authorize_resource class: 'Recipe'
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
    if @recipe.save
      flash[:notice] = "Successfully created recipe."
      go_back(@recipe)
    else
      flash.now[:alert] = @recipe.errors if @recipe.errors.any?
      render :new
    end
  end

  def update
    if @recipe.update_attributes(recipe_params)
      flash[:notice] = "Successfully updated recipe."
      go_back(recipes_path)
    else
      flash.now[:alert] = @recipe.errors if @recipe.errors.any?
      render :edit
    end
  end

  def destroy
    @recipe.destroy
    flash[:notice] = "Successfully destroyed recipe."
    go_back(recipes_path)
  end

  private
    def setup
      case action_name
      when 'new','create'
        @page_heading = "New Recipe"
        @buttons = %i(save cancel)
      when 'edit','update'
        @page_heading = "Edit Recipe #{@recipe.name}"
        @buttons = %i(save cancel)
      when 'show'
        @page_heading = "#{@recipe.name}"
        @buttons = %i(edit delete index)
      when 'index'
        @page_heading = "Recipes"
        @buttons = %i(new)
      end
    end

    def recipe_params
      params.require(:recipe).permit(Recipe.permitted_attributes)
    end

end
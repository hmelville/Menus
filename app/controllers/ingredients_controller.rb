class IngredientsController < ApplicationController

  load_and_authorize_resource :ingredient, class: 'Ingredient'

  before_action :setup
  skip_before_action :verify_authenticity_token

  BACK_TO_KEY = :ingredient_return_to

  def back_to_key
    BACK_TO_KEY
  end

  def index
  end

  def new
  end

  def create
    if @ingredient.save
      flash[:notice] = "Successfully created ingredient."
      go_back(ingredients_path)
    else
      flash.now[:alert] = @ingredient.errors if @ingredient.errors.any?
      render :new
    end
  end

  def update
    if @ingredient.update_attributes(ingredient_params)
      flash[:notice] = "Successfully updated ingredient."
      go_back(ingredients_path)
    else
      flash.now[:alert] = @ingredient.errors if @ingredient.errors.any?
      render :edit
    end
  end

  def destroy
    @ingredient.destroy
    flash[:notice] = "Successfully destroyed ingredient."
    go_back(ingredients_path)
  end

  private
    def setup
      case action_name
      when 'new','create'
        @page_heading = "New Ingredient"
        @buttons = %i(save cancel)
      when 'edit','update'
        @page_heading = "Edit Ingredient #{@ingredient.name}"
        @buttons = %i(save cancel)
      when 'show'
        @page_heading = "#{@ingredient.name}"
        @buttons = %i(edit delete index)
      when 'index'
        @page_heading = "Ingredients"
        @buttons = %i(new)
      end
    end

    def ingredient_params
      params.require(:ingredient).permit(Ingredient.permitted_attributes)
    end
end
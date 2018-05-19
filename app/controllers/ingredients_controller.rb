class IngredientsController < ApplicationController
  before_action :set_back, only: [:new, :edit]
  before_action :setup
  skip_before_action :verify_authenticity_token

  def index
    @ingredients = Ingredient.all
  end

  def new
    @ingredient = Ingredient.new()
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    if @ingredient.save
      flash[:notice] = "Successfully created ingredient."
      redirect_to session[:ingredient_return_to]
    else
      flash.now[:alert] = @ingredient.errors if @ingredient.errors.any?
      render :new
    end
  end

  def update
    if @ingredient.update(ingredient_params)
      flash[:notice] = "Successfully updated ingredient."
      redirect_to session[:ingredient_return_to]
    else
      flash.now[:alert] = @ingredient.errors if @ingredient.errors.any?
      render :edit
    end
  end

  def destroy
    @ingredient.destroy
    flash[:notice] = "Successfully destroyed ingredient."
    redirect_to ingredients_path
  end

  private
    def set_back
      session[:ingredient_return_to] = request.referer
    end

    def setup
      if params[:id]
        @ingredient ||= Ingredient.find(params[:id])
      end

      case action_name
      when 'new','create'
        @ingredient_page_heading = "New Ingredient"
        @ingredient_buttons = %i(save cancel)
      when 'edit','update'
        @ingredient_page_heading = "Edit Ingredient #{@ingredient.name}"
        @ingredient_buttons = %i(save cancel)
      when 'show'
        @ingredient_page_heading = "#{@ingredient.name}"
        @ingredient_buttons = %i(edit delete index)
      when 'index'
        @ingredient_page_heading = "Ingredients"
        @ingredient_buttons = %i(new)
      end
    end

    def ingredient_params
      params.require(:ingredient).permit(:name)
    end
end
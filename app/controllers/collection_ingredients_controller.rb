class CollectionIngredientsController < ApplicationController
  before_action :set_back, only: [:new, :edit]
  before_action :setup
  skip_before_action :verify_authenticity_token

  def new
    @collection = Collection.find(params[:collection_id])
    @collection_ingredient = CollectionIngredient.new(collection_id: @collection.id)
  end

  def create
    @collection = Collection.find(params[:collection_ingredient][:collection_id])
    @collection_ingredient = CollectionIngredient.new(collection_ingredient_params)
    if @collection_ingredient.save
      flash[:notice] = "Successfully added ingredient."
      redirect_to session[:collection_ingredient_return_to]
    else
      byebug
      flash.now[:alert] = @collection_ingredient.errors if @collection_ingredient.errors.any?
      render :new
    end
  end

  def update
    if @collection_ingredient.update_attributes(collection_ingredient_params)
      flash[:notice] = "Successfully updated ingredient."
      redirect_to session[:collection_ingredient_return_to]
    else
      flash.now[:alert] = @collection_ingredient.errors if @collection_ingredient.errors.any?
      render :edit
    end
  end

  def destroy
    @collection_ingredient.destroy
    flash[:notice] = "Successfully destroyed ingredient."
    redirect_to session[:collection_ingredient_return_to]
  end

  private
    def set_back
      session[:collection_ingredient_return_to] = request.referer
    end

    def setup
      if params[:id]
        @collection_ingredient ||= CollectionIngredient.find(params[:id])
        @collection ||= @collection_ingredient.collection
      elsif params[:collection_id]
        @collection = Collection.find(params[:collection_id])
      end

      case action_name
      when 'new','create'
        @collection_ingredient_page_heading = "New Ingredient"
        @collection_ingredient_buttons = %i(save cancel)
      when 'edit','update'
        @collection_ingredient_page_heading = "Edit Ingredient"
        @collection_ingredient_buttons = %i(save cancel delete)
      when 'show'
        @collection_ingredient_page_heading = "#{@collection_ingredient.ingredient.name}"
        @collection_ingredient_buttons = %i(edit delete index)
      end
    end

    def collection_ingredient_params
      params.require(:collection_ingredient).permit(:collection_id, :ingredient_id, :quantity, :unit_id)
    end
end

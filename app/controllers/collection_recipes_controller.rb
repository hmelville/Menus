class CollectionRecipesController < ApplicationController
  before_action :set_back, only: [:new, :edit]
  before_action :setup
  skip_before_action :verify_authenticity_token

  def new
    @collection = Collection.find(params[:collection_id])
    @collection_recipe = CollectionRecipe.new(collection_id: @collection.id)
  end

  def create
    @collection = Collection.find(params[:collection_recipe][:collection_id])
    @collection_recipe = CollectionRecipe.new(collection_recipe_params)
    if @collection_recipe.save
      flash[:notice] = "Successfully added recipe."
      redirect_to session[:collection_recipe_return_to]
    else
      byebug
      flash.now[:alert] = @collection_recipe.errors if @collection_recipe.errors.any?
      render :new
    end
  end

  def update
    if @collection_recipe.update_attributes(collection_recipe_params)
      flash[:notice] = "Successfully updated menu."
      redirect_to session[:collection_recipe_return_to]
    else
      flash.now[:alert] = @collection_recipe.errors if @collection_recipe.errors.any?
      render :edit
    end
  end

  def destroy
    @collection_recipe.destroy
    flash[:notice] = "Successfully destroyed recipe."
    redirect_to session[:collection_recipe_return_to]
  end

  private
    def set_back
      session[:collection_recipe_return_to] = request.referer
    end

    def setup
      if params[:id]
        @collection_recipe ||= CollectionRecipe.find(params[:id])
        @collection ||= @collection_recipe.collection
      elsif params[:collection_id]
        @collection = Collection.find(params[:collection_id])
      end

      case action_name
      when 'new','create'
        @collection_recipe_page_heading = "New Recipe"
        @collection_recipe_buttons = %i(save cancel)
      when 'edit','update'
        @collection_recipe_page_heading = "Edit Recipe"
        @collection_recipe_buttons = %i(save cancel delete)
      when 'show'
        @collection_recipe_page_heading = "#{@collection_recipe.recipe.name}"
        @collection_recipe_buttons = %i(edit delete index)
      end
    end

    def collection_recipe_params
      params.require(:collection_recipe).permit(:collection_id, :recipe_id)
    end
end

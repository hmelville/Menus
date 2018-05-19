class CollectionMealsController < ApplicationController
  before_action :set_back, only: [:new, :edit]
  before_action :setup
  skip_before_action :verify_authenticity_token

  def new
    @collection = Collection.find(params[:collection_id])
    @collection_meal = CollectionMeal.new(collection_id: @collection.id)
  end

  def create
    @collection = Collection.find(params[:collection_meal][:collection_id])
    @collection_meal = CollectionMeal.new(collection_meal_params)
    if @collection_meal.save
      flash[:notice] = "Successfully added meal."
      redirect_to session[:collection_meal_return_to]
    else
      byebug
      flash.now[:alert] = @collection_meal.errors if @collection_meal.errors.any?
      render :new
    end
  end

  def update
    if @collection_meal.update_attributes(collection_meal_params)
      flash[:notice] = "Successfully updated menu."
      redirect_to session[:collection_meal_return_to]
    else
      flash.now[:alert] = @collection_meal.errors if @collection_meal.errors.any?
      render :edit
    end
  end

  def destroy
    @collection_meal.destroy
    flash[:notice] = "Successfully destroyed meal."
    redirect_to session[:collection_meal_return_to]
  end

  private
    def set_back
      session[:collection_meal_return_to] = request.referer
    end

    def setup
      if params[:id]
        @collection_meal ||= CollectionMeal.find(params[:id])
        @collection ||= @collection_meal.collection
      elsif params[:collection_id]
        @collection = Collection.find(params[:collection_id])
      end

      case action_name
      when 'new','create'
        @collection_meal_page_heading = "New Meal"
        @collection_meal_buttons = %i(save cancel)
      when 'edit','update'
        @collection_meal_page_heading = "Edit Meal"
        @collection_meal_buttons = %i(save cancel delete)
      when 'show'
        @collection_meal_page_heading = "#{@collection_meal.meal.name}"
        @collection_meal_buttons = %i(edit delete index)
      end
    end

    def collection_meal_params
      params.require(:collection_meal).permit(:collection_id, :meal_id)
    end
end

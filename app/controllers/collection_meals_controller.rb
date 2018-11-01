class CollectionMealsController < ApplicationController

  load_and_authorize_resource :menu_rotation, class: 'MenuRotation'
  load_and_authorize_resource :shopping_list, class: 'ShoppingList'
  load_and_authorize_resource :shopping_list_day, class: 'ShoppingListDay'
  load_and_authorize_resource :collection_meal, class: 'CollectionMeal', through: [:menu_rotation, :shopping_list, :shopping_list_day]

  before_action :setup
  skip_before_action :verify_authenticity_token

  BACK_TO_KEY = :collection_meal_return_to

  def back_to_key
    BACK_TO_KEY
  end

  def new
  end

  def create
    if @collection_meal.save
      flash[:notice] = "Successfully added meal."
      go_back
    else
      flash.now[:alert] = @collection_meal.errors if @collection_meal.errors.any?
      render :new
    end
  end

  def update
    if @collection_meal.update_attributes(collection_meal_params)
      flash[:notice] = "Successfully updated meal."
      go_back
    else
      flash.now[:alert] = @collection_meal.errors if @collection_meal.errors.any?
      render :edit
    end
  end

  def destroy
    @collection_meal.destroy
    flash[:notice] = "Successfully destroyed meal."
    go_back
  end

  def delete
    target = @collection_meal.target
    this_id = "row_#{@collection_meal.class.table_name}_#{@collection_meal.id}"
    parent_id = "row_#{target.class.table_name}_#{target.id}"
    @collection_meal.destroy
    target.reload
    if target.class.name != "MenuRotations" && (target.collection_meals.any? || Rails.application.routes.recognize_path(request.referrer)[:action] == "show" || target.class.name == "ShoppingList")
      render json: {id: this_id, html: render_to_string(nothing: true, status: :ok, content_type: "text/html") }
    else
      render json: {id: parent_id, html: render_to_string(partial: "#{target.class.table_name}/index_row", locals: {target: target}), expand: true }
    end
  end

  private

    def setup
      case action_name
      when 'new','create'
        @page_heading = "New Meal"
        @buttons = %i(save cancel)
        @meals = current_user.meals.all
      when 'edit','update'
        @page_heading = "Edit Meal"
        @buttons = %i(save cancel delete)
        @meals = current_user.meals.all
      when 'show'
        @page_heading = "#{@collection_meal.name}"
        @buttons = %i(edit delete index)
      end
    end

    def collection_meal_params
      params.require(:collection_meal).permit(CollectionMeal.permitted_attributes)
    end
end
class CollectionRecipesController < ApplicationController

  load_and_authorize_resource :meal, class: 'Meal'
  load_and_authorize_resource :menu_rotation, class: 'MenuRotation'
  load_and_authorize_resource :shopping_list, class: 'ShoppingList'
  load_and_authorize_resource :shopping_list_day, class: 'ShoppingListDay'
  load_and_authorize_resource :collection_recipe, class: 'CollectionRecipe', through: [:meal, :menu_rotation, :shopping_list, :shopping_list_day]

  before_action :setup
  skip_before_action :verify_authenticity_token

  BACK_TO_KEY = :collection_recipe_return_to

  def back_to_key
    BACK_TO_KEY
  end

  def new
  end

  def create
    if @collection_recipe.save
      flash[:notice] = "Successfully added recipe."
      go_back
    else
      byebug
      flash.now[:alert] = @collection_recipe.errors if @collection_recipe.errors.any?
      render :new
    end
  end

  def update
    if @collection_recipe.update_attributes(collection_recipe_params)
      flash[:notice] = "Successfully updated recipe."
      go_back
    else
      flash.now[:alert] = @collection_recipe.errors if @collection_recipe.errors.any?
      render :edit
    end
  end

  def destroy
    @collection_recipe.destroy
    flash[:notice] = "Successfully destroyed recipe."
    go_back
  end

  def delete
    target =  @collection_recipe.target
    this_id = "row_#{@collection_recipe.class.table_name}_#{@collection_recipe.id}"
    parent_id = "row_#{target.class.table_name}_#{target.id}"
    @collection_recipe.destroy
    target.reload
    if target.class.name != "MenuRotations" && (target.collection_recipes.any? || Rails.application.routes.recognize_path(request.referrer)[:action] == "show" || target.class.name == "ShoppingList")
      render json: {id: this_id, html: render_to_string(nothing: true, status: :ok, content_type: "text/html") }
    else
      render json: {id: parent_id, html: render_to_string(partial: "#{target.class.table_name}/index_row", locals: {target: target}), expand: true }
    end
  end

  private

    def setup
      case action_name
      when 'new','create'
        @heading = "Add Recipe"
        @buttons = %i(save cancel)
        @recipes = current_user.recipes.all
      when 'edit','update'
        @heading = "Edit Recipe"
        @buttons = %i(save cancel delete)
        @recipes = current_user.recipes.all
      when 'show'
        @heading = "#{@collection_recipe.name}"
        @buttons = %i(edit delete index)
      end
    end

    def collection_recipe_params
      params.require(:collection_recipe).permit(CollectionRecipe.permitted_attributes)
    end
end
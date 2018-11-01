class CollectionIngredientsController < ApplicationController

  load_and_authorize_resource :recipe, class: 'Recipe'
  load_and_authorize_resource :meal, class: 'Meal'
  load_and_authorize_resource :menu_rotation, class: 'MenuRotation'
  load_and_authorize_resource :shopping_list, class: 'ShoppingList'
  load_and_authorize_resource :shopping_list_day, class: 'ShoppingListDay'
  load_and_authorize_resource :collection_ingredient, class: 'CollectionIngredient', through: [:recipe, :meal, :menu_rotation, :shopping_list, :shopping_list_day]

  before_action :setup, except: [:add_quantity, :deduct_quantity, :destroy]

  skip_before_action :verify_authenticity_token

  BACK_TO_KEY = :collection_ingredient_return_to

  def back_to_key
    BACK_TO_KEY
  end

  def new
  end

  def create
    if @collection_ingredient.save
      flash[:notice] = "Successfully added ingredient."
      go_back
    else
      flash.now[:alert] = @collection_ingredient.errors if @collection_ingredient.errors.any?
      render :new
    end
  end

  def update
    if @collection_ingredient.update_attributes(collection_ingredient_params)
      flash[:notice] = "Successfully updated ingredient."
      go_back
    else
      flash.now[:alert] = @collection_ingredient.errors if @collection_ingredient.errors.any?
      render :edit
    end
  end

  def destroy
    @collection_ingredient.destroy
    flash[:notice] = "Successfully destroyed ingredient."
    go_back
  end

  def add_quantity
    alter_quantity(1, params[:partial])
  end

  def deduct_quantity
    alter_quantity(-1, params[:partial])
  end

  def delete
    target =  @collection_ingredient.target
    this_id = "row_#{@collection_ingredient.class.table_name}_#{@collection_ingredient.id}"
    parent_id = "row_#{target.class.table_name}_#{target.id}"
    if target.soft_delete
      @collection_ingredient.update_attribute(:deleted_at, DateTime.now)
    else
      @collection_ingredient.destroy
    end
    target.reload
    if target.class.name != "MenuRotations" && (target.collection_ingredients.any? || Rails.application.routes.recognize_path(request.referrer)[:action] == "show" || target.class.name == "ShoppingList")
      render json: {id: this_id, html: render_to_string(nothing: true, status: :ok, content_type: "text/html") }
    else
      render json: {id: parent_id, html: render_to_string(partial: "#{target.class.table_name}/index_row", locals: {target: target}), expand: true }
    end
  end

  private
    def setup
      case action_name
      when 'new','create'
        @page_heading = "Add Ingredient"
        @buttons = %i(save cancel)
        @ingredients = current_user.ingredients.all
      when 'edit','update'
        @page_heading = "Edit Ingredient"
        @buttons = %i(save cancel delete)
        @ingredients = current_user.ingredients.accessible_by(current_ability)
      when 'show'
        @page_heading = "#{@collection_ingredient.name}"
        @buttons = %i(edit delete index)
      end
    end

    def alter_quantity(qty, partial)
      target =  @collection_ingredient.target
      this_id = "row_#{@collection_ingredient.class.table_name}_#{@collection_ingredient.id}"
      parent_id = "row_#{target.class.table_name}_#{target.id}"
      cur_qty = @collection_ingredient.quantity
      if (cur_qty + qty) > 0
        CollectionIngredient.update_counters(@collection_ingredient, quantity: qty)
        @collection_ingredient.reload
        render json: {id: this_id, html: render_to_string(partial: partial, locals: { target: @collection_ingredient.target, collection_ingredient: @collection_ingredient, show_actions: true, depth: 0 }) }
      else
        @collection_ingredient.update_attribute(:deleted_at, DateTime.now)
        if target.class.name != "MenuRotations" && (target.collection_ingredients.any? || Rails.application.routes.recognize_path(request.referrer)[:action] == "show" || target.class.name == "ShoppingList")
          render json: {id: this_id, html: render_to_string(nothing: true, status: :ok, content_type: "text/html") }
        else
          render json: {id: parent_id, html: render_to_string(partial: "#{target.class.table_name}/index_row", locals: {target: target}), expand: true }
        end
      end
    end

    def collection_ingredient_params
      params.require(:collection_ingredient).permit(CollectionIngredient.permitted_attributes)
    end
end
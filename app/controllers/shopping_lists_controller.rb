class ShoppingListsController < ApplicationController

  load_and_authorize_resource :shopping_list, class: 'ShoppingList'

  before_action :setup
  skip_before_action :verify_authenticity_token

  def show
  end

  def index
    redirect_to @shopping_lists.first
  end

  def undo_last_delete
    last_record =  @shopping_list.collection_ingredients.with_deleted.order(deleted_at: :desc).first
    if last_record
      last_record.update_attribute(:deleted_at, nil)
      flash[:notice] = "Successfully restored ingredient."
    else
      flash[:notice] = "Nothing to restore!"
    end
    redirect_to @shopping_list
  end

  private
    def setup

      case action_name
      when 'new','create'
        @page_heading = "Add Ingredient"
        @buttons = %i(save cancel)
        @ingredients = current_user.ingredients.all
      when 'show'
        @page_heading = "Shopping List"
        @buttons = %i(new undo)
        @ingredients = current_user.ingredients.all
      end
    end

    def shopping_list_params
      params.require(:shopping_list).permit(ShoppingList.permitted_attributes)
    end
end
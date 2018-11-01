class ShoppingListDaysController < ApplicationController

  load_and_authorize_resource :shopping_list_day, class: 'ShoppingListDay'

  before_action :setup
  skip_before_action :verify_authenticity_token

  def show
  end

  def index
  end

  def build_days
    current_user.build_shopping_list_days(params[:build_days][:start_date].to_date, params[:build_days][:end_date].to_date)
    redirect_to shopping_list_days_path
  end

  def build_list
    current_user.build_shopping_list
    redirect_to current_user.shopping_list
  end

  private
    def setup
      @start_date = current_user.shopping_list_days.minimum(:the_date) || Date.today
      @end_date = current_user.shopping_list_days.maximum(:the_date) || Date.today + (current_user.default_shopping_days).days

      case action_name
      when 'show'
        @page_heading = "#{@shopping_list_day.day_name}"
        @buttons = %i(index)
      end
    end
end
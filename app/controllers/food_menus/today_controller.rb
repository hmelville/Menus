module FoodMenus
  class TodayController < BaseController
    skip_before_action :verify_authenticity_token

    def index
      @today = Date.today
      shopping_list_day = FoodMenus::ShoppingListDay.find_by(the_date: @today)
      if shopping_list_day.present?
        @collection = shopping_list_day.collection
      else
        if FoodMenus::MenuRotation.any?
          @collection = FoodMenus::MenuRotation.get_rotation_by_date(@today).collection
        end
      end
    end
  end
end
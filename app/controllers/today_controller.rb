class TodayController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @today = Date.today
    shopping_list_day = current_user.shopping_list_days.find_by(the_date: @today)
    if shopping_list_day.present?
      @collection = shopping_list_day
    else
      if current_user.menu_rotations.any?
        @collection = current_user.get_rotation_by_date(@today)
      end
    end
  end
end
class Setting < ActiveRecord::Base

  validates :menu_rotation_weeks, numericality: { greater_than: 0 }
  validates_presence_of :menu_rotation_weeks, :menu_rotation_start_date

  WEEKS = [1,2,3,4]
  DAYS =
    {
      1 => "Sunday",
      2 => "Monday",
      3 => "Tuesday",
      4 => "Wednesday",
      5 => "Thursday",
      6 => "Friday",
      7 => "Saturday"
    }

end

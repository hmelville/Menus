class MenuRotation < ::ApplicationBase

  belongs_to :user

  has_many :collection_meals, as: :target, dependent: :destroy
  has_many :meals, through: :collection_meals

  has_many :collection_recipes, as: :target, dependent: :destroy
  has_many :recipes, through: :collection_recipes

  has_many :collection_ingredients, as: :target, dependent: :destroy
  has_many :ingredients, through: :collection_ingredients

  default_scope { order(:week, :day) }

  def week_day_name
    "Week #{week} - Day #{day} - #{day_name}"
  end

  def day_of_week(num_days)
    (user.menu_rotation_start_date + (num_days.days)).wday
  end

  def day_name
    (user.menu_rotation_start_date + ((week - 1) * 7 + (day - 1)).days).strftime("%A")
  end

  def is_today?
    h = user.menu_rotation.get_day_week_by_date(Date.today, user)
    h[:week] == week && h[:day] == day
  end

  def get_all_ingredients(ingredient_id = 0, unit_id = 0)
    all_ingredients = []

    meals.each do |m|
      all_ingredients += m.get_all_ingredients(ingredient_id, unit_id)
    end

    recipes.each do |r|
      all_ingredients += r.get_all_ingredients(ingredient_id, unit_id)
    end

    all_ingredients += collection_ingredients.where("(ingredient_id = ? OR ? = 0) AND (collection_ingredients.unit_id = ? OR ? = 0)", ingredient_id, ingredient_id, unit_id, unit_id)

    return all_ingredients
  end

  def main_recipes
    recipe_names = []
    meals.collect {|cm| recipe_names += cm.recipes.collect(&:name) }
    recipe_names += recipes.collect.collect(&:name)
    return recipe_names.uniq.sort.to_sentence
  end
end
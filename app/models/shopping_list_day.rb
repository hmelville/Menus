class ShoppingListDay < ::ApplicationBase

  belongs_to :user

  has_many :collection_meals, as: :target, dependent: :destroy
  has_many :meals, through: :collection_meals

  has_many :collection_recipes, as: :target, dependent: :destroy
  has_many :recipes, through: :collection_recipes

  has_many :collection_ingredients, as: :target, dependent: :destroy
  has_many :ingredients, through: :collection_ingredients

  default_scope { order(:the_date) }

  def name
    the_date.strftime("%d/%m/%Y - %A")
  end

  def day_name
    the_date.strftime("%d/%m/%Y - %A")
  end

  def main_recipes
    recipe_names = []
    meals.collect {|cm| recipe_names += cm.recipes.collect(&:name) }
    recipe_names += recipes.collect.collect(&:name)
    return recipe_names.uniq.sort.to_sentence
  end

  def self.start_date
    all.where(user: current_user).minimum(:the_date)
  end

  def self.end_date
    all.where(user: current_user).maximum(:the_date)
  end

  def self.start_date_name
    if start_date.present?
      start_date.strftime("%A %d/%m/%Y")
    else
      nil
    end
  end

  def self.end_date_name
    if end_date.present?
      end_date.strftime("%A %d/%m/%Y")
    else
      nil
    end
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
end
class CollectionMeal < ::ApplicationBase

  belongs_to :target, polymorphic: true
  belongs_to :meal

  default_scope { joins(:meal).order("meals.name") }

  def name
    meal.name
  end
end
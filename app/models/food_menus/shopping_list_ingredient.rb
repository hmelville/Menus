module FoodMenus
  class ShoppingListIngredient < ActiveRecord::Base

    belongs_to :shopping_list
    belongs_to :ingredient
    belongs_to :unit

    validates_presence_of :ingredient_id, :shopping_list_id

    default_scope { joins(:ingredient).order("ingredients.name") }

    def name
      self.ingredient.name
    end

    def to_s
      "#{self.ingredient.name} (#{self.quantity}#{self.unit.try(:abbreviation)})"
    end

    def to_unit(u)
      (self.quantity.to_f / u.conversion_rate) * (self.unit.conversion_rate)
    end
  end
end
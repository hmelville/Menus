module FoodMenus
  class IngredientSupplier < ActiveRecord::Base
    belongs_to :ingredient
    belongs_to :supplier

    validates_presence_of :ingredient_id, :supplier_id
    validates_uniqueness_of :supplier_id, scope: :ingredient_id
    validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
    validates :aisle, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

    default_scope { joins(:supplier).order("suppliers.name") }

  end
end
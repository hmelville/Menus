module FoodMenus
  class Supplier < ActiveRecord::Base

    has_many :ingredient_suppliers, dependent: :destroy

    has_many :ingredients, through: :ingredient_suppliers

    validates :name, presence: true
    validates_uniqueness_of :name

    default_scope { order(:name) }

  end
end
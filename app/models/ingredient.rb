class Ingredient < ActiveRecord::Base

  has_one :collection, as: :target, dependent: :destroy
  after_create :create_collection

  # has_many :meal_ingredients, dependent: :destroy
  # has_many :meals, through: :meal_ingredients

  # has_many :recipe_ingredients, dependent: :destroy
  # has_many :recipes, through: :recipe_ingredients

  has_many :ingredient_suppliers, dependent: :destroy
  has_many :suppliers, through: :ingredient_suppliers

  validates :name, presence: true
  validates_uniqueness_of :name

  default_scope { order(:name) }
end

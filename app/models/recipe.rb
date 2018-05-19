class Recipe < ActiveRecord::Base

  has_one :collection, as: :target, dependent: :destroy
  after_create :create_collection

  # has_many :meal_recipes, dependent: :destroy
  # has_many :meals, through: :meal_recipes

  # has_many :recipe_ingredients, dependent: :destroy
  # has_many :ingredients, through: :recipe_ingredients

  validates :name, presence: true
  validates_uniqueness_of :name

  default_scope { order(:name) }

end

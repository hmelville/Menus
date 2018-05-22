module FoodMenus
  class Recipe < ActiveRecord::Base

    has_one :collection, as: :target, dependent: :destroy
    after_create :create_collection

    validates :name, presence: true
    validates_uniqueness_of :name

    default_scope { order(:name) }

  end
end
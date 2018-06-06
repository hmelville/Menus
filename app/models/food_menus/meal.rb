module FoodMenus
  class Meal < ::ApplicationBase

    belongs_to :user
    has_one :collection, as: :target, dependent: :destroy
    after_create :create_collection

    validates :name, presence: true
    validates_uniqueness_of :name, scope: :user_id

    default_scope { order(:name) }
  end
end
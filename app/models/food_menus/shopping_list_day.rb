module FoodMenus
  class ShoppingListDay < ::ApplicationBase

    belongs_to :shopping_list
    has_one :collection, as: :target, dependent: :destroy
    after_create :create_collection


    default_scope { order(:the_date) }
    def name
      the_date.strftime("%d/%m/%Y - %A")
    end
    def day_name
      the_date.strftime("%d/%m/%Y - %A")
    end
  end
end
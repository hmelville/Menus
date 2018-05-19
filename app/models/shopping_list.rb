class ShoppingList < ActiveRecord::Base

  has_many :shopping_list_days, dependent: :destroy
  has_many :shopping_list_ingredients, dependent: :destroy

  def start_date_name
    if start_date.present?
      start_date.strftime("%A %d/%m/%Y")
    else
      nil
    end
  end

  def end_date_name
    if end_date.present?
      end_date.strftime("%A %d/%m/%Y")
    else
      nil
    end
  end

  def get_all_ingredients(ingredient_id = 0)
    all_ingredients = []

    shopping_list_days.each do |sld|
      all_ingredients += sld.collection.get_all_ingredients(ingredient_id)
    end

    return all_ingredients
  end

  def build_shopping_list_days
    shopping_list_days.destroy_all
    (start_date..end_date).each do |the_date|

      shopping_list_day = shopping_list_days.create(the_date: the_date)

      menu_rotation = MenuRotation.get_rotation_by_date(the_date)

      if menu_rotation.present?
        if menu_rotation.collection.present?
          menu_rotation.collection.collection_meals.each do |meal|
            shopping_list_day.collection.collection_meals.create(meal.dup.attributes)
          end

          menu_rotation.collection.collection_recipes.each do |recipe|
            shopping_list_day.collection.collection_recipes.create(recipe.dup.attributes)
          end

          menu_rotation.collection.collection_ingredients.each do |ingredient|
            shopping_list_day.collection.collection_ingredients.create(ingredient.dup.attributes)
          end
        end
      end
    end
  end


  def build_shopping_list_ingredients
    shopping_list_ingredients.destroy_all

    if shopping_list_days.present?
      shopping_list_days.each do |shopping_list_day|
        if shopping_list_day.collection.present?
          shopping_list_day.collection.get_all_ingredients.each do |col_ingredient|
            add_ingredient(col_ingredient)
          end
        end
      end
    end
  end

  def add_ingredient(new_ingredient)
    existing = shopping_list_ingredients.find_by(ingredient_id: new_ingredient.ingredient_id)
    if existing.present?
      if existing.unit_id == new_ingredient.unit_id
        existing.update_attributes(quantity: (existing.quantity + new_ingredient.quantity))
      else
      end
    else
      shopping_list_ingredients.create(ingredient_id: new_ingredient.ingredient_id, unit_id: new_ingredient.unit_id, quantity: new_ingredient.quantity)
    end
  end
end
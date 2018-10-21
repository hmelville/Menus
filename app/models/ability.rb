class Ability
  include CanCan::Ability

  def initialize(user)

    if user.present?
      can :manage, User, id: user.id
      can :manage, FoodMenus::Ingredient, user_id: user.id
      can :manage, FoodMenus::Ingredients::IngredientSupplier, ingredient: { user_id: user.id }
      can :manage, FoodMenus::Recipe, user_id: user.id
      can :manage, FoodMenus::Meal, user_id: user.id
      can :manage, FoodMenus::Supplier, user_id: user.id
      can :manage, FoodMenus::MenuRotation, user_id: user.id
      can :manage, FoodMenus::ShoppingList, user_id: user.id
    end
  end
end

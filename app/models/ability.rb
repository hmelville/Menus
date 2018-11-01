class Ability
  include CanCan::Ability

  def initialize(user)

    if user.present?
      can :manage, User, id: user.id
      can :manage, Ingredient, user_id: user.id
      can :manage, Ingredients::IngredientSupplier, ingredient: { user_id: user.id }
      can :manage, Recipe, user_id: user.id
      can :manage, Meal, user_id: user.id
      can :manage, Supplier, user_id: user.id
      can :manage, MenuRotation, user_id: user.id
      can :manage, ShoppingList, user_id: user.id
      can :manage, ShoppingListDay, user_id: user.id

      can :manage, CollectionMeal, target: { user_id: user.id }
      can :manage, CollectionRecipe, target: { user_id: user.id }
      can :manage, CollectionIngredient, target: { user_id: user.id }

    end
  end
end

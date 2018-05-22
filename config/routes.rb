Rails.application.routes.draw do
  namespace :food_menus do
    resources :today, only: [:index]
    resources :meals
    resources :menu_rotations
    resources :recipes
    resources :ingredients
    resources :ingredient_suppliers
    resources :suppliers
    resources :units
    resources :settings
    resources :shopping_lists do
      member do
        get :create_menus, action: 'create_menus'
        get :build_shopping_list, action: 'build_shopping_list'
      end
    end
    resources :shopping_list_days
    resources :shopping_list_ingredients do
      member do
        get :add_quantity, action: 'add_quantity'
        get :deduct_quantity, action: 'deduct_quantity'
      end
    end
    resources :collection_meals
    resources :collection_recipes
    resources :collection_ingredients


    root 'today#index'
  end
end

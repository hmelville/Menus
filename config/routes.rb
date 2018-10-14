Rails.application.routes.draw do

  resource :session
  resource :account do
    get 'password', :action => 'password', :as => :password_recovery
    post 'password', :action => 'password_sent'
    get 'password_reset/:token', :action => 'password_reset', :as => :password_reset, purpose: "password_reset"
    put 'password_reset/:token', :action => 'update_password'
    get 'subscription_edit/:subscription_token', :action => 'subscription_edit', :as => :subscription_edit
    get 'subscription_edit', :action => 'subscription_edit' # this route is just to prevent a routing exception if malformed request (without a token) is received
    get 'subscribe/:subscription_token', :action => 'subscribe', :as => :subscribe
    get 'subscribe', :action => 'subscribe' # this route is just to prevent a routing exception if malformed request (without a token) is received
    put 'subscribe/:subscription_token', :action => 'subscribe'
    get 'unsubscribe/:subscription_token', :action => 'unsubscribe', :as => :unsubscribe
    get 'unsubscribe', :action => 'unsubscribe' # this route is just to prevent a routing exception if malformed request (without a token) is received
    put 'unsubscribe/:subscription_token', :action => 'unsubscribe'
    get 'close'
  end

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

  end

  namespace :budgets do
    resources :accounts do
      resources :balances
      resources :expenses
      resources :payments
      resources :transactions
    end
  end

  resources :users, :only => [:edit, :update] do
    resource :controls, :only => [:new, :destroy]
  end

  root 'pages#welcome'
end

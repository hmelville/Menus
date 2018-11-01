Rails.application.routes.draw do

  resource :session
  resource :user do
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

  resources :today, only: [:index]

  resources :ingredients do
    resources :ingredient_suppliers, controller: 'ingredients/ingredient_suppliers'
  end

  resources :recipes do
    resources :collection_ingredients, controller: 'collection_ingredients' do
      member do
        post :add_quantity, action: 'add_quantity'
        post :deduct_quantity, action: 'deduct_quantity'
        post :delete, action: 'delete'
      end
    end
  end

  resources :meals do
    resources :collection_recipes, controller: 'collection_recipes' do
      member do
        post :delete, action: 'delete'
      end
    end
    resources :collection_ingredients, controller: 'collection_ingredients' do
      member do
        post :add_quantity, action: 'add_quantity'
        post :deduct_quantity, action: 'deduct_quantity'
        post :delete, action: 'delete'
      end
    end
  end

  resources :menu_rotations do
    resources :collection_meals, controller: 'collection_meals' do
      member do
        post :delete, action: 'delete'
      end
    end
    resources :collection_recipes, controller: 'collection_recipes' do
      member do
        post :delete, action: 'delete'
      end
    end
    resources :collection_ingredients, controller: 'collection_ingredients' do
      member do
        post :add_quantity, action: 'add_quantity'
        post :deduct_quantity, action: 'deduct_quantity'
        post :delete, action: 'delete'
      end
    end
  end

  resources :suppliers
  resources :units

  resources :shopping_lists do
    member do
      post :undo_last_delete
    end
    resources :collection_ingredients, controller: 'collection_ingredients' do
      member do
        post :add_quantity, action: 'add_quantity'
        post :deduct_quantity, action: 'deduct_quantity'
        post :delete, action: 'delete'
      end
    end
  end

  resources :shopping_list_days do
    collection do
      post :build_days, action: 'build_days'
      post :build_list, action: 'build_list'
    end
    resources :collection_meals, controller: 'collection_meals' do
      member do
        post :delete, action: 'delete'
      end
    end
    resources :collection_recipes, controller: 'collection_recipes' do
      member do
        post :delete, action: 'delete'
      end
    end
    resources :collection_ingredients, controller: 'collection_ingredients' do
      member do
        post :add_quantity, action: 'add_quantity'
        post :deduct_quantity, action: 'deduct_quantity'
        post :delete, action: 'delete'
      end
    end
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

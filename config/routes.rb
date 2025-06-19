Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: "makers#index", as: :authenticated_root
  end

  root to: "pages#home" # fallback root path for unauthenticated users

  # Karma and Pages
  get '/karma_info', to: 'pages#karma', as: :karma_info
  get '/karma', to: 'karma#dashboard', as: :karma_dashboard

  # Makers and nested resources
  resources :makers, except: [:edit, :update, :destroy] do
    collection do
      get :map
    end

    resources :reviews, only: [:new, :create]

    member do
      post :favorite
      post :unfavorite
    end
  end

  resources :users do
    get :favorites, on: :collection
  end

  # Products
  resources :products, only: [:new, :create]

  # Questions
  resources :questions, only: [:index, :create] do
    collection do
      get :reset
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end

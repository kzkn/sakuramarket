Rails.application.routes.draw do
  root to: "products#index"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"

  resources :products, only: %i(index show)

  resource :cart, only: %i(show update)
  namespace :cart do
    resources :items, only: %i(destroy)
  end

  resources :orders, only: %i(index show new create)

  get "/admin", to: "admin/home#show"
  namespace :admin do
    resources :users, only: %i(index show edit update destroy)
    resources :products, only: %i(index show new edit create update) do
      member do
        put :position
      end
    end
  end
end

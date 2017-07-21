Rails.application.routes.draw do
  root to: "products#index"

  resources :products, only: %i(index show)
  resource :cart, only: %i(show update)

  get "/admin", to: "admin/home#show"
  namespace :admin do
    resources :users, only: %i(index show edit update destroy)
    resources :products, only: %i(index show new edit create update)
  end
end

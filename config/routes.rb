Rails.application.routes.draw do

  get "/admin", to: "admin/home#show"
  namespace :admin do
    resources :users, only: %i(index show edit update destroy)
    resources :products, only: %i(index show new edit create update)
  end
end

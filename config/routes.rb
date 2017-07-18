Rails.application.routes.draw do

  namespace :admin do
    resources :users, only: %i(index show edit update destroy)
    resources :products, only: %i(index show new edit create update)
  end
end

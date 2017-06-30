# -*- coding: utf-8 -*-
Rails.application.routes.draw do
  root 'home#index'

  # TODO この辺はあとで整理する
  get '/login', to: 'login#show'
  post '/login', to: 'login#create'
  post '/logout', to: 'logout#create'
  get '/signup', to: 'signup#show'
  post '/signup', to: 'signup#create'

  get '/delivery', to: 'delivery_destinations#edit', as: 'delivery'
  post '/delivery', to: 'delivery_destinations#update'

  resources :products, only: [:show] do
    member do
      get 'image'
    end
  end

  namespace :admin do
    resources :products do
      member do
        post 'up'
        post 'down'
      end
    end
  end
end

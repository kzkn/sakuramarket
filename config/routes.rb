# -*- coding: utf-8 -*-
Rails.application.routes.draw do
  root 'home#index'

  # TODO 全体的にもう少しスッキリできそう
  get '/login', to: 'login#show'
  post '/login', to: 'login#create'
  post '/logout', to: 'logout#create'
  get '/signup', to: 'signup#show'
  post '/signup', to: 'signup#create'

  resources :products, only: [:show] do
    member do
      get 'image'
    end
  end

  resource :cart, only: [:show] do
    resources :items, only: [:create, :update, :destroy], module: 'cart'
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

# -*- coding: utf-8 -*-
Rails.application.routes.draw do
  root 'home#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resource :signup, only: [:show, :create]

  resources :details, only: [:show]

  resources :products, only: [] do
    resource :image, only: [:show], module: :products
  end

  resource :cart, only: [:show, :update] do
    resources :items, only: [:destroy], module: :carts
  end

  resource :order, only: [:show, :create] do
    resources :histories, only: [:index, :show]
  end

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :products do
      member do
        post 'up'
        post 'down'
      end
    end
  end
end

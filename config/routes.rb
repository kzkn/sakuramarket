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

  resource :orders, only: [:new, :create]
  namespace :orders do
    resources :histories, only: [:index, :show]
  end

  resource :admin, only: [:show]
  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :products do
      resource 'position', only: [:update], module: :products
    end
  end
end

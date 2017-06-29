Rails.application.routes.draw do
  resources :products do
    member do
      get 'image'
      post 'up'
      post 'down'
    end
  end
  root 'home#index'

  get '/login', to: 'login#show'
  post '/login', to: 'login#create'
  post '/logout', to: 'logout#create'
  get '/signup', to: 'signup#show'
  post '/signup', to: 'signup#create'

  get '/delivery', to: 'delivery_destinations#edit', as: 'delivery'
  post '/delivery', to: 'delivery_destinations#update'
end

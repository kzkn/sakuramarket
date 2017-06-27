Rails.application.routes.draw do
  root "home#index"

  get "/login", to: "login#show"
  post "/login", to: "login#create"
  post "/logout", to: "logout#create"
end

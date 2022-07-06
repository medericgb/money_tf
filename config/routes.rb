require 'sidekiq/web'

Rails.application.routes.draw do
  get "/users", to: "users#index"
  get "/user/sold", to: "users#sold"
  get "/user/transactions", to: "users#transactions"

  get "/agencies", to: "agencies#index"
  get "/agency/sold", to: "agencies#sold"
  get "/agency/transactions", to: "agencies#transactions"

  post "/users/create", to: "users#create"
  post "/agencies/create", "agencies#create"
  
  post "/users/deposit", to: "users#deposit"
  post "/users/transfer", to: "users#transfer"
  post "/users/withdraw", to: "users#withdraw"
  post "/agency/transfer", to: "agencies#transfer"
  post "/agency/withdraw", to: "agencies#withdraw"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

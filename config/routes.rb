Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :destroy]
  resources :friendships, only: [:create, :destroy]
  devise_for :users
  get "up" => "health#show", as: :rails_health_check
  root "welcome#index"
  get "my_portfolio", to: "users#my_portfolio"
  get "search_stocks", to: "stocks#search"
  get "my_friends", to: "users#my_friends"
  get "search_friends", to: "users#search_friends"
end

Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :destroy]
  #devise_for :users
  root "welcome#index"
  get '/welcome', to: "welcome#index"
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  get "/my_portfolio", to: "users#my_portfolio"
  get '/search_stock', to: "stocks#search"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

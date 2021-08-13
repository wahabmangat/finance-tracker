Rails.application.routes.draw do
  devise_for :users
  root "welcome#index"
  get '/welcome', to: "welcome#index"
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

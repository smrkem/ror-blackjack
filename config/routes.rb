Rails.application.routes.draw do
  get 'karlos/index'

  root to: "health_statuses#new"
  resources :health_statuses

  resources :users, controller: :users, only: :create
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

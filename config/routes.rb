Rails.application.routes.draw do
  root to: "health_statuses#new"
  resources :health_statuses

  resources :users, controller: :users, only: :create

  get "/confirm_email/:token" => "email_confirmations#update", as: "confirm_email"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

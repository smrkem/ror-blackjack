Rails.application.routes.draw do
  root to: "goals#index"

  resources :goals do
    post 'complete_now', on: :member
    get 'deactivate', on: :member, as: "deactivate"
    resources :goal_activities, only: [:new, :create, :destroy]
  end
  resources :health_statuses


  resources :users, controller: :users, only: [:create] do
      resource :password,
        controller: "clearance/passwords",
        only: [:create, :edit, :update]
  end

  get "/confirm_email/:token" => "email_confirmations#update", as: "confirm_email"

  get "/my-settings" => "users#edit", as: "my_settings"
  patch "/my-settings" => "users#update", as: "update_settings"

  get "/inactive-goals" => "goals#inactive_goals", as: "inactive_goals"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  root to: "rubberducks#index"
  resources :rubber_ducks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :users do
    resources :rubberducks
  end

  resources :rubberducks, only: [:index, :show] do
    resources :bookings, only: [:new, :create, :index]
  end
end

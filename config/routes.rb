Rails.application.routes.draw do
  get 'home/index'
  
  resources :users do
    resources :children
  end
  
  resources :program_enrollments do
    resources :reading_entries, only: [:create, :update]
  end
  
  resources :programs
  resources :collections
  resources :literary_works do
    member do
      get 'read', to: 'literary_works#read'
    end
  end
  resources :reading_entries

  revise_auth
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end

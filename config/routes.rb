Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :index, :show]
      resources :sessions, only: :create
      resources :movies, only: [:index, :show]
      resources :viewing_parties, only: [:create, :update]    #Plural, though kinda doesn't make sense here...
      resources :viewing_party_registrations, only: :create

      #Need to add some more here.  For now, no nesting needed.  Of note:
      #Users - update the above: retrieve profile (show)
      #Movies - get top rated (index), search (index), details (show)
      #ViewingParty - new party (create), add new user (update)
    end
  end
end

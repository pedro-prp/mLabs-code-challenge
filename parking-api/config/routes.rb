Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "hello" => "application#hello"

  
  # Authentication
  post "login", to: "auth#login"
  post "register", to: "auth#register"

  # Parking API
  
  resources :parking, only: [:create] do
    member do
      put 'pay'
      put 'out'
    end
    collection do
      get "/:plate", to: "parking#history"
    end
  end

end

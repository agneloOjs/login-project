Rails.application.routes.draw do
  root "pages/website/home#index"

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  namespace :api, path: "" do
    namespace :v1, path: "" do
      post "auth-login", to: "auth#login"
      post "auth-register", to: "auth#register"
      post "logout", to: "auth#destroy"

      resources :users, only: [ :index, :show, :create, :update, :destroy ]
      # resources :properties, only: [ :index, :show, :create, :update, :destroy ]
    end
  end

  namespace :pages, path: "" do
    namespace :auth do
      get "session", to: "sessions#new"
      get "registration", to: "registrations#new"
      get "reset-password", to: "passwords#new", as: :reset_password
    end

    namespace :imob do
      namespace :admin do
        get "dashboard", to: "dashboard#index", as: :dashboard
        # get "usuarios", to: "users#index", as: :users
        resources :users, only: [ :index, :new, :create ]
      end
    end
  end
end

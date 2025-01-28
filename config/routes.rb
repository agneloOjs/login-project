Rails.application.routes.draw do
  root "pages/website/home#index"

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  namespace :api, path: "" do
    namespace :v1, path: "" do
      post "auth/login", to: "auth#login"
      post "auth/register", to: "auth#register"
      delete "auth/logout", to: "auth#logout"

      resources :users, only: [ :index, :show, :create, :update, :destroy ]
      # resources :properties, only: [ :index, :show, :create, :update, :destroy ]
    end
  end

  namespace :pages, path: "" do
    namespace :auth do
      resources :sessions, only: [ :index, :new, :create, :destroy ]
      resources :registrations, only: [ :new, :create ]
      get "reset-password", to: "passwords#reset", as: :reset_password
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

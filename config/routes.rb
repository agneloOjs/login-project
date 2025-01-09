Rails.application.routes.draw do
  root "pages/website/home#index"

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  namespace :pages, path: "" do
    namespace :auth do
      get "sessions", to: "sessions#index", as: :sessions
      get "registrations", to: "registrations#index", as: :registrations
      get "reset-password", to: "passwords#reset", as: :reset_password
    end
  end
end

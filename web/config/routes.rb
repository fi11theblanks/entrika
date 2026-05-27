Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :companies, only: [:index, :show] do
    resources :messages, only: [:create]
    resources :registrations, only: [:create]
  end
  resources :registrations, only: [:update]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :companies, only: [:show, :create] do
        resources :registrations, only: [:create]
      end
      devise_scope :user do
        post "login", to: "users/sessions#create"
        delete "logout", to: "users/sessions#destroy"
      end
    end
  end

  get "dashboard", to: "pages#dashboard", as: :dashboard
  get "sitesanalyzed", to: "registrations#index", as: :sitesanalyzed
end

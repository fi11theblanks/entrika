Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :companies, only: %w[index show create] do
    resources :messages, only: [:create]
    resources :registrations, only: [:create]
  end
  resources :registrations, only: [:update]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :companies, only: %w[show create] do
        collection do
          get :search
          post :analyze
        end
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

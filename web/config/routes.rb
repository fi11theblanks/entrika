Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :companies, only: [:index, :show] do
    resources :messages, only: [:create]
  end
  resources :registrations, only: [:update]
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :companies, only: [:show, :create] do
        resources :registrations, only: [:create]
      end
      devise_for :users,
        path: "",
        path_name_names: {
          sign_in: "login",
          sign_out: "logout"
        },
        controllers: {
          sessions: "api/v1/users/sessions"
      }
    end
  end

  get "dashboard", to: "registration#index", as: :dashboard
end

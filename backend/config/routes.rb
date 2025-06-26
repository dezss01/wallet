Rails.application.routes.draw do
  devise_for :users,
              path: "api/users",
              path_names: {
                sign_in: "login",
                sign_out: "logout",
                registration: "signup"
              },
              controllers: {
                sessions: "users/sessions",
                registrations: "users/registrations"
              }, defaults: { format: :json }

  namespace :api do
    namespace :v1 do
      resources :accounts do
        resources :transactions, controller: "account_transactions", only: [ :index, :create ]
      end
      resources :transactions, controller: "account_transactions", only: [ :show, :update, :destroy ]
    end
  end
end

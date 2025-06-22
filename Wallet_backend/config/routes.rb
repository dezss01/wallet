Rails.application.routes.draw do
  namespace :api do
    devise_for :users,
               controllers: {
                 sessions: "users/sessions",
                 registrations: "users/registrations"
               },
               defaults: { format: :json }
    namespace :v1 do
      resources :accounts do
        resources :transactions, controller: "account_transactions", only: [ :index, :create ]
      end
      resources :transactions, controller: "account_transactions", only: [ :show, :update, :destroy ]
    end
  end
end

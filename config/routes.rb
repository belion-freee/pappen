Rails.application.routes.draw do
  root to: "home#index"

  post "/show",    to: "home#show",    as: :show
  post "/options", to: "home#options", as: :options

  resources :inter_changes
end

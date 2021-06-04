Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  post "/line",    to: "home#line",    as: :line

  get "/alive", to: "alive#index", as: :alive # for health check
  get "/debug", to: "home#debug", as: :debug  # for debug

  resources :line_users, only: %i[] do
    resources :expenditures, only: %i[index create update destroy]
  end

  resources :events, only: %i[show update] do
    resources :expenses, only: %i[create update destroy]
    get :gas, on: :collection
  end

  resources :houses, only: %i[show update] do
    resources :house_expenditures, only: %i[update create destroy]
  end
end

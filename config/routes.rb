Rails.application.routes.draw do
  root to: "home#index"

  # for health check
  get "/alive", to: "alive#index", as: :alive

  post "/tweet",   to: "home#tweet",   as: :tweet
  post "/line",    to: "home#line",    as: :line
  post "/paid",    to: "events#paid",  as: :paid

  # it is for debug
  get "/debug", to: "home#debug", as: :debug

  resources :maxims, except: %i[new edit show]
  resources :events
  resources :expenses

  # expenditure
  resources :expenditures, only: [:edit, :update, :destroy]

  get "/expenditures/:line_user_id", to: "expenditures#index", as: :expenditures
  get "/expenditure/new/:line_user_id", to: "expenditures#new", as: :new_expenditure
  post "/expenditures/:line_user_id", to: "expenditures#create", as: :post_expenditure

  resources :houses do
    resources :house_expenditure
  end
end

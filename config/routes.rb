Rails.application.routes.draw do
  root to: "home#index"

  post "/tweet",   to: "home#tweet",   as: :tweet
  post "/line",    to: "home#line",    as: :line
  post "/paid",    to: "events#paid",  as: :paid

  # it is for debug
  get "/debug", to: "home#debug", as: :debug

  resources :maxims, except: [:show]
  resources :events
  resources :expenses

  # expenditure
  resources :expenditures, only: [:edit, :update, :destroy]

  get "/expenditures/:line_user_id", to: "expenditures#index", as: :expenditures
  get "/expenditure/new/:line_user_id", to: "expenditures#new", as: :new_expenditure
  post "/expenditures/:line_user_id", to: "expenditures#create", as: :post_expenditure
end

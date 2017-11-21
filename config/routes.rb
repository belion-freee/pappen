Rails.application.routes.draw do
  root to: "home#index"

  post "/tweet",   to: "home#tweet",   as: :tweet
  post "/line",    to: "home#line",    as: :line

  # it is for debug
  get "/debug", to: "home#debug", as: :debug

  resources :maxims
end

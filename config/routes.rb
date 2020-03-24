Rails.application.routes.draw do
  get '/values/new', to: 'values#new'
  get '/values/show', to: 'values#show'
  get '/values/index', to: 'values#index'
  post '/values', to: 'values#create'
  resources :values
end

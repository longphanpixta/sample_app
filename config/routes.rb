Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help', to: 'static_pages#help', as: 'help'
  get '/about', to: 'static_pages#about'
  get '/contract', to: 'static_pages#contract'
  get '/signup', to: 'users#new'

  resources :users

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end

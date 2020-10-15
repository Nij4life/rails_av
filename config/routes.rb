Rails.application.routes.draw do
  # get 'welcome/index'

  post '/tasks', to: 'tasks#create'
  delete '/tasks', to: 'tasks#destroy'

  resources :categories
  root 'categories#index'
end

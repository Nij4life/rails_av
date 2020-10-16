Rails.application.routes.draw do
  # post 'tasks' => 'tasks#create'

  resources :categories do
    resource :tasks, only: %i[new, create destroy] # route new не появляеться
  end

  root 'categories#index'
end

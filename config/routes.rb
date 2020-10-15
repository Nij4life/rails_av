Rails.application.routes.draw do
  resources :categories do
    resources :products
  end
  root 'categories#index'
end

Rails.application.routes.draw do
  get 'products/index'
  get 'categories/index'
  root 'categories#index'
end

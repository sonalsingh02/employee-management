Rails.application.routes.draw do


  root 'home#index'

  devise_for :employees
  resources :employees, only: [] do
  	resources :profiles
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

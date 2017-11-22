Rails.application.routes.draw do
  get 'leaves/index'

  get 'leaves/new'

  get 'leaves/create'

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
  root 'home#index' 

  devise_for :employees
  resources :employees, only: [] do
  	resources :profiles
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

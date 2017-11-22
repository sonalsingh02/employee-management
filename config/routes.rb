Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
  root 'home#index' 

  devise_for :employees
  resources :employees, only: [] do
  	resources :profiles
  end

  

  resources :employees do
    resources :leaves_histories do
      member do
      	get :approve_leave
        get :disapprove_leave
      end
    end
  end

  resources :employees do
    resources :leaves_histories do
      collection do
      	get :show_leaves
      end
    end
  end
end

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
        get :cancel_leave
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

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        collection do
          post :create
        end
        collection do
          get :show
        end
      end
      resources :leaves_histories, only: [] do
        collection do
          post :apply
        end
        collection do
          get :show_leaves
        end
      end
    end
	end
end

Rails.application.routes.draw do
  devise_for :employees
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
  root 'home#index' 

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
      resources :profiles do
        collection do
          post :create_profile
        end
        collection do
          get :show_profile
        end
      end
      resources :leaves_histories do
        collection do
          post :create_leave
        end
        collection do
          get :show_leaves
        end
      end
    end
	end
end

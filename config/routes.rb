Rails.application.routes.draw do
  devise_for :users

  root 'projects#index'

  resources :yarn_database, except: [:destroy] do
    member do
      patch :update_attribution
    end
  end

  resources :projects do
    member do
      delete :destroy_image
      patch :update_attribution
    end
  end

  resources :journal_entries, only: [:create, :update, :destroy]

  resources :stash_yarns do
    member do
      patch :update_attribution
    end
  end

  resources :yarn_companies, except: [:destroy]

  resources :crafters, only: [:show] do
    member do
      get :projects
      get :stash
    end
  end

  namespace :admin do
    resources :users, except: [:destroy] do
      member do
        patch :enable
        patch :disable
      end
    end
  end
end

Rails.application.routes.draw do
  devise_for :users

  root 'projects#index'

  resources :yarn_database, except: [:destroy]
  resources :projects do
    member do
      delete :destroy_image
    end
  end
  resources :journal_entries, only: [:create, :update, :destroy]
  resources :stash_yarns
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

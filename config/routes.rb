Rails.application.routes.draw do
  devise_for :users

  root 'projects#index'

  resources :yarn_database, as: 'yarn_products', except: [:destroy] do
    member do
      patch :update_attribution
    end

    resources :colorways, only: [:index, :edit, :create, :update] do
      patch :update_attribution, on: :member
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

  resources :yarn_companies, except: [:destroy] do
    collection do
      get :autocomplete_name
    end
  end

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

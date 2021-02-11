Rails.application.routes.draw do
  devise_for :users

  root 'projects#index'

  resources :yarn_database, as: 'yarn_products', except: [:destroy] do
    member do
      patch :update_attribution
    end
    collection do
      get :autocomplete_name
      get :autocomplete_name_for_stash
    end

    resources :colorways, only: [:index, :edit, :create, :update] do
      patch :update_attribution, on: :member
      collection do
        get :autocomplete_name_or_number
        get :autocomplete_name_or_number_for_stash
      end
    end
  end

  resources :colorways, only: [:create]

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
      get :autocomplete_name_for_stash
    end
  end

  resources :crafters, only: [:show, :edit, :update] do
    member do
      get :projects
      get :stash
    end
  end

  resources :stash_usages, only: [:create] do
    collection do
      delete :destroy # we delete by project and stash yarn, not stash_usage.id
      get :autocomplete_project
      get :autocomplete_stash_yarn
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

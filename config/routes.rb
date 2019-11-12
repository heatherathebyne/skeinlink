Rails.application.routes.draw do
  devise_for :users
  root 'projects#index'

  resources :yarns
  resources :projects do
    member do
      delete :destroy_image
    end
  end
  resources :journal_entries, only: [:create, :update, :destroy]
end

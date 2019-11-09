Rails.application.routes.draw do
  root 'projects#index'

  resources :yarns
  resources :projects
end

require 'sidekiq/web'

Rails.application.routes.draw do
  root to: "static#index"
  get '/', to: "static#index", as: :welcome

  get 'domains', to: "domains#index", as: :domains
  get 'domains/:id', to: "domains#view", as: :domain
  # get 'websites', to: "websites#index", as: :websites
  # get 'websites/:id', to: "websites#view", as: :website

  get "about", to: "static#about", as: :about

  get 'reports', to: "reports#index", as: :reports
   
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  mount Sidekiq::Web => "/sidekiq"
end

require 'sidekiq/web'

Rails.application.routes.draw do
  root to: "domains#index"
  get '/', to: "domains#index", as: :welcome
  get 'index', to: "static#index", as: :index

  # Only allow authenticated users to access the domain loader.
  devise_scope :user do
    authenticated :user do
      get 'domains/load', to: "domains#load", as: :domains_loader
      post 'domains/load', to: "domains#load", as: :load_domains
    end
  end
  
  get 'domains', to: "domains#index", as: :domains
  post 'domains', to: "domains#queue", as: :domain_queue
  get 'domains/:id', to: "domains#view", as: :domain

  # get 'websites', to: "websites#index", as: :websites
  # get 'websites/:id', to: "websites#view", as: :website

  get "about", to: "static#about", as: :about
  get "sunburst", to: "static#sunburst", as: :sunburst

  get 'reports', to: "reports#index", as: :reports
  get 'reports/:id', to: "reports#download", as: :report_download
   
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Only allow authenticated users to get access to the Sidekiq web interface
  devise_scope :user do
    authenticated :user do
      mount Sidekiq::Web => "/sidekiq"
    end
  end

  get "users", to: "users#index", as: :users

  devise_for :users
end

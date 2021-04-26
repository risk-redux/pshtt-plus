require 'sidekiq/web'

Rails.application.routes.draw do
  get 'domains/index'
  get 'domains/view'
  get "about", to: "static#about", as: :about
  root to: "static#index"
  get 'static/index'
  get 'static/about'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  mount Sidekiq::Web => "/sidekiq"
end

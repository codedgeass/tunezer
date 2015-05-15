Groups::Application.routes.draw do
  concern :commentable do
    resources :comments, only: [:create, :index, :show, :destroy]
  end
  
  resources :locations
  
  resources :cities, concerns: :commentable, controller: 'location'
  
  resources :states, concerns: :commentable, controller: 'location'
  
  resources :countries, concerns: :commentable, controller: 'location'
  
  resources :genres, concerns: :commentable, controller: 'location'

  resources :venues, concerns: :commentable, controller: 'location'

  devise_for :users
  
  resources :ratings, only: [:create, :update]
  
  resources :profiles, only: [:edit, :show, :update] do
    resources :notifications, only: [:destroy]
  end
  
  resources :concerts, concerns: :commentable  do
    resources :videos, only: [:new, :create, :index, :show, :destroy]
  end
  
  root to: 'concerts#index'
end
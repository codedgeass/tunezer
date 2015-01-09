Groups::Application.routes.draw do
  devise_for :users
  resources :ratings, only: [:create, :update]
  resources :profiles, only: [:edit, :show, :update] do
    resources :notifications, only: [:destroy]
  end
  resources :productions  do
    resources :videos, only: [:new, :create, :index, :show, :destroy]
    resources :comments, only: [:create, :index, :destroy]
    resources :concerts, only: [:new, :create, :index, :show, :destroy]
  end
  root to: 'productions#index'
end
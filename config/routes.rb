Rails.application.routes.draw do
  devise_for :users
  
  root 'items#index'
  
  resources :items, only: [:index, :new, :create, :edit, :update, :show, :destroy] do
    resources :orders, only: [:index, :create]  # 必要であれば追加
  end
  
  resources :categories, only: [:index, :show]
  resources :brands, only: [:index, :show]
end
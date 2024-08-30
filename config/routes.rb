Rails.application.routes.draw do
  devise_for :users
  
  root 'items#index'
  
  resources :items, only: [:index, :new, :create, :edit, :update, :show] do
    # 商品購入機能実装時に有効
    # resources :orders, only: [:index, :create]
  end
  
  resources :categories, only: [:index, :show]
  resources :brands, only: [:index, :show]
end
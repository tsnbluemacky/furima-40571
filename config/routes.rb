Rails.application.routes.draw do
  devise_for :users
  
  root 'items#index'
  
  # 必要なアクションを定義
  resources :items, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    # 商品購入機能実装時に有効にする
    # resources :orders, only: [:index, :create]
  end

  # カテゴリとブランドのルートを一旦削除（現時点で使わないから）
  # resources :categories, only: [:index, :show]
  # resources :brands, only: [:index, :show]
end
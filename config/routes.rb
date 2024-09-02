Rails.application.routes.draw do
  devise_for :users
  
  root 'items#index'
  
  # 必要なアクションを定義
  resources :items do
    resources :orders, only: [:new, :create, :destroy] # ここで orders のルートを追加
  end

  # カテゴリとブランドのルートを一旦削除（現時点で使わないため）
  # resources :categories, only: [:index, :show]
  # resources :brands, only: [:index, :show]
end
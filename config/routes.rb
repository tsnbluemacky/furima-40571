Rails.application.routes.draw do
  devise_for :users
  
  # アプリケーションのルートを設定
  root 'items#index'  
  
  resources :items do
 
  end

 
  resources :categories, only: [:index, :show]
  
  # brandsリソースのルーティングを追加
  resources :brands, only: [:index, :show]

  # 他に追加するルートがあれば
end

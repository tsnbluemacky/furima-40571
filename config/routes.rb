Rails.application.routes.draw do
  devise_for :users
  
  # アプリケーションのルートを設定
  root 'items#index'  
  
  # itemsリソースに関するルーティングを設定
  resources :items do
    # 必要に応じて、itemsに関連するネストされたリソースを追加
    # 例えば、commentsリソースをネストする場合は以下のように記述する
    # resources :comments, only: [:create, :destroy]
  end

  # categoriesリソースのルーティングを追加
  resources :categories, only: [:index, :show]
  
  # brandsリソースのルーティングを追加
  resources :brands, only: [:index, :show]

  # 他に追加するルートがあればここに記述
end

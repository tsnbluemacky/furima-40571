Rails.application.routes.draw do
  devise_for :users

  root 'items#index'

  # 商品出品、詳細表示、購入機能のアクションを定義
  resources :items do
    # 出品機能: newアクションで出品フォームを表示
    # 購入機能: indexで購入確認ページ、createで購入処理
    resources :orders, only: [:index, :create]
  end
end
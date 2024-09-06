class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:index, :create]
  before_action :check_purchase_permissions, only: [:index, :create]

  def index
    @order_address = OrderAddress.new
    gon.public_key = ENV['PAYJP_PUBLIC_KEY'] # PAYJPの公開鍵をフロントエンドに渡す
  end

  def create
    @order_address = OrderAddress.new(order_address_params)
    if @order_address.valid?
      begin
        process_payment
        @order_address.save
        redirect_to root_path, notice: '購入が完了しました'
      rescue Payjp::CardError => e
        handle_payment_error(e)
      rescue StandardError => e
        handle_payment_error(e)
      end
    else
      gon.public_key = ENV['PAYJP_PUBLIC_KEY']
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  # 購入できるかの条件をまとめてチェック
  def check_purchase_permissions
    if current_user.id == @item.user_id
      redirect_to root_path, alert: '自身の商品は購入できません。'
    elsif @item.order.present?
      redirect_to root_path, alert: 'この商品は既に購入されています。'
    end
  end

  def order_address_params
    params.require(:order_address).permit(:postal_code, :prefecture_id, :city, :address, :building, :phone_number).merge(
      user_id: current_user.id, item_id: @item.id, token: params[:token]
    )
  end

  # 決済処理
  def process_payment
    # PAYJPの秘密鍵を環境変数から読み込む
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']

    # 決済のためのチャージ処理
    Payjp::Charge.create(
      amount: @item.price, # 商品の価格を設定
      card: order_address_params[:token], # フロントエンドから送られたカードトークン
      currency: 'jpy' # 日本円での決済
    )
  end

  # 決済エラー処理
  def handle_payment_error(error)
    # エラーメッセージをログに残す
    Rails.logger.error("Payment failed: #{error.message}")
    # ユーザーにエラーメッセージを表示
    flash[:alert] = "決済に失敗しました: #{error.message}"
    render :index, status: :unprocessable_entity
  end
end

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
      handle_purchase(@order_address) # 購入処理をサービスクラスに委任
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

  # 購入処理をサービスオブジェクトに委譲
  def handle_purchase(order_address)
    PurchaseService.new(order_address, @item).process
    redirect_to root_path, notice: '購入が完了しました'
  rescue PaymentError => e
    flash[:alert] = e.message
    render :index, status: :unprocessable_entity
  end
end

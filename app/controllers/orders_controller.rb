class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:index, :create]

  def index
    gon.public_key = ENV["PAYJP_PUBLIC_KEY"]
    @order_form = OrderAddress.new
    # ユーザーが自身のアイテムを購入しないようにする
    return redirect_to root_path if @item.user_id == current_user.id || @item.order.present?
  end

  def create
    @order_form = OrderAddress.new(order_params)
    if @order_form.valid?
      pay_item  # 支払い処理
      @order_form.save  # 注文と住所の保存処理
      redirect_to root_path
    else
      gon.public_key = ENV["PAYJP_PUBLIC_KEY"]
      render :index, status: :unprocessable_entity
    end
  end

  private

  # アイテムの取得
  def set_item
    @item = Item.find(params[:item_id])
  end

  # 注文フォームのパラメータを強化
  def order_params
    params.require(:order_address).permit(:postal_code, :prefecture_id, :city, :address, :building_name, :phone_number
    ).merge(
      user_id: current_user.id, item_id: @item.id, token: params[:token]
    )
  end

  # 支払い処理
  def pay_item
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    Payjp::Charge.create(
      amount: @item.price,
      card: order_params[:token],
      currency: 'jpy'
    )
  end
end
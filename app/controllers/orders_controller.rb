class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :redirect_if_not_allowed, only: [:index, :create]

  def index
    @order_address = OrderAddress.new
  end

  def create
    @order_address = OrderAddress.new(order_address_params)
    if @order_address.valid?
      if PaymentService.new(@item.price, order_address_params[:token]).process
        @order_address.save
        redirect_to root_path, notice: '購入が完了しました'
      else
        flash[:alert] = '決済に失敗しました。もう一度お試しください。'
        render :index, status: :unprocessable_entity # エラーハンドリング時にindexへ戻る
      end
    else
      render :index, status: :unprocessable_entity # エラーハンドリング時にindexへ戻る
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def order_address_params
    params.require(:order_address).permit(:postal_code, :prefecture_id, :city, :address, :building, :phone_number).merge(
      user_id: current_user.id, item_id: @item.id, token: params[:token]
    )
  end

  def redirect_if_not_allowed
    return unless @item.order.present? || current_user.id == @item.user_id

    redirect_to root_path, alert: 'この商品は購入できません。'
  end
end

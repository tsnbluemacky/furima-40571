# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_item, only: [:index, :create]
  before_action :check_user_permissions, only: [:index, :create]

  def index
    @order_address = OrderAddress.new
    gon.public_key = ENV['PAYJP_PUBLIC_KEY'] # 公開キーをフロントエンドで利用
  end

  def create
    @order_address = OrderAddress.new(order_params)

    if @order_address.valid?
      ActiveRecord::Base.transaction do
        if process_payment
          @order_address.save
          @item.update(status: 'sold_out')
          redirect_to root_path, notice: I18n.t('notices.purchase_complete')
        else
          raise ActiveRecord::Rollback, I18n.t('errors.messages.payment_failed')
        end
      end
    else
      handle_validation_failure
    end
  rescue Payjp::CardError => e
    handle_payment_error(e)
  rescue Timeout::Error, SocketError => e
    handle_network_error(e)
  rescue StandardError => e
    handle_generic_error(e)
  end

  private

  def process_payment
    Payjp.api_key = Rails.application.credentials.payjp[:secret_key]
    charge = Payjp::Charge.create(
      amount: @item.price,
      card: order_params[:token],
      currency: 'jpy'
    )
    charge.paid # 決済が成功したかどうかを確認
  end

  def find_item
    @item = Item.find(params[:item_id])
  end

  def check_user_permissions
    if current_user.id == @item.user_id || @item.order.present?
      redirect_to root_path, alert: I18n.t('alerts.purchase_not_allowed')
    end
  end

  def order_params
    params.require(:order_address).permit(
      :postal_code, :prefecture_id, :city, :address, :building_name, :phone_number
    ).merge(
      item_id: @item.id, user_id: current_user.id, token: params[:token]
    )
  end

  def handle_payment_error(error)
    log_and_flash_error(error, I18n.t('errors.messages.payment_failed'))
  end

  def handle_network_error(error)
    log_and_flash_error(error, I18n.t('errors.messages.network_error'))
  end

  def handle_generic_error(error)
    log_and_flash_error(error, I18n.t('errors.messages.unexpected_error'))
  end

  def log_and_flash_error(error, message)
    Rails.logger.error "#{message}: #{error.message}"
    flash[:alert] = message
    render :index, status: :unprocessable_entity
  end

  def handle_validation_failure
    flash.now[:alert] = @order_address.errors.full_messages.uniq.join(", ")
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
    render :index, status: :unprocessable_entity
  end
end

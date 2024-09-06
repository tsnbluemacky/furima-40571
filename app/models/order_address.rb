# app/models/order_address.rb
class OrderAddress
  include ActiveModel::Model
  attr_accessor :postal_code, :prefecture_id, :city, :address, :building, :phone_number, :user_id, :item_id, :token

  # バリデーションルールの統合
  with_options presence: true do
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: I18n.t('errors.messages.invalid_postal_code') }
    validates :prefecture_id, numericality: { other_than: 0, message: I18n.t('errors.messages.invalid_prefecture') }
    validates :city, presence: { message: I18n.t('errors.messages.blank_city') }
    validates :address, presence: { message: I18n.t('errors.messages.blank_address') }
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: I18n.t('errors.messages.invalid_phone_number') }
    validates :token, presence: { message: I18n.t('errors.messages.blank_token') }
    validates :user_id, :item_id, presence: true
  end

  # メインの保存処理
  def save
    ActiveRecord::Base.transaction do
      order = create_order!
      create_address!(order.id)
    end
  rescue ActiveRecord::RecordInvalid => e
    log_error("Order saving failed", e)
    add_validation_errors(e.record.errors)
    false
  rescue Payjp::CardError => e
    log_payment_error(e)
    false
  end

  private

  # Orderを作成する
  def create_order!
    Order.create!(user_id: user_id, item_id: item_id, token: token)
  end

  # Addressを作成する
  def create_address!(order_id)
    Address.create!(
      postal_code: postal_code, prefecture_id: prefecture_id, city: city,
      address: address, building: building, phone_number: phone_number, order_id: order_id
    )
  end

  # エラーログを出力
  def log_error(message, exception)
    Rails.logger.error "#{message}: #{exception.message}"
  end

  # 決済エラーログ
  def log_payment_error(exception)
    Rails.logger.error "Payment failed: #{exception.message}"
    errors.add(:base, "決済に失敗しました: #{exception.message}")
  end

  # バリデーションエラーをエラーメッセージに追加
  def add_validation_errors(error_messages)
    error_messages.each do |attribute, message|
      errors.add(attribute, message)
    end
  end
end
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
    validates :user_id, :item_id
  end

  # トランザクションでOrderとAddressを同時に保存
  def save
    ActiveRecord::Base.transaction do
      order = create_order
      create_address(order.id)
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    handle_error(e) # エラーが発生した場合のエラーハンドリング
    false
  end

  private

  # Orderを作成するメソッド
  def create_order
    Order.create!(user_id:, item_id:)
  end

  # Addressを作成するメソッド
  def create_address(order_id)
    Address.create!(postal_code:, prefecture_id:, city:, address:,
                    building:, phone_number:, order_id:)
  end

  # エラーハンドリングとログ出力を統合
  def handle_error(exception)
    Rails.logger.error "Purchase failed: #{exception.message}"
    errors.add(:base, I18n.t('errors.messages.transaction_failed'))

    # 例外が発生したフィールドごとのエラーメッセージを追加
    exception.record.errors.each do |attr, message|
      errors.add(attr, message)
    end
  end
end

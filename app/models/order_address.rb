# app/models/order_address.rb
class OrderAddress
  include ActiveModel::Model
  attr_accessor :postal_code, :prefecture_id, :city, :address, :building_name, :phone_number, :user_id, :item_id, :token

  # バリデーション
  with_options presence: true do
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/ }
    validates :prefecture_id, numericality: { other_than: 0}
    validates :city
    validates :address
    validates :phone_number
    validates :user_id
    validates :item_id
    validates :token
  end

  # 保存処理
  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      order = create_order
      create_address(order.id)
    end
  rescue ActiveRecord::RecordInvalid => e
    log_error('Order saving failed', e)
    false
  end

  private

  # Orderの作成
  def create_order
    Order.create!(user_id: user_id, item_id: item_id)
  end

  # Addressの作成
  def create_address(order_id)
    Address.create!(
      postal_code: postal_code, prefecture_id: prefecture_id, city: city,
      address: address, building_name: building_name, phone_number: phone_number, order_id: order_id
    )
  end

  # エラーログの出力
  def log_error(message, exception)
    Rails.logger.error "#{message}: #{exception.message}\n#{exception.backtrace.join("\n")}"
    errors.add(:base, '保存に失敗しました。再度お試しください。')
  end
end

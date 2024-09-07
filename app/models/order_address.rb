# app/models/order_address.rb
class OrderAddress
  include ActiveModel::Model
  attr_accessor :postal_code, :prefecture_id, :city, :address, :building_name, :phone_number, :user_id, :item_id, :token

  # バリデーション
  with_options presence: true do
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: '郵便番号は「123-4567」の形式で入力してください' }
    validates :prefecture_id, numericality: { other_than: 0, message: '都道府県を選択してください' }
    validates :city, :address
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: '電話番号は10桁または11桁で入力してください' }
    validates :token
    validates :user_id, :item_id
  end

  # 保存処理
  def save
    ActiveRecord::Base.transaction do
      order = create_order
      create_address(order.id)
    end
  rescue ActiveRecord::RecordInvalid => e
    log_error("保存に失敗しました", e)
    false
  end

  private

  def create_order
    Order.create!(user_id: user_id, item_id: item_id)
  end

  def create_address(order_id)
    Address.create!(
      postal_code: postal_code, prefecture_id: prefecture_id, city: city,
      address: address, building_name: building_name, phone_number: phone_number, order_id: order_id
    )
  end

  # エラーログを出力
  def log_error(message, exception)
    Rails.logger.error "#{message}: #{exception.message}"
    errors.add(:base, '保存に失敗しました。再度お試しください。')
  end
end
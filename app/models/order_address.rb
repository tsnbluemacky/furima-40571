class OrderAddress
  include ActiveModel::Model
  attr_accessor :postal_code, :prefecture_id, :city, :address, :building, :phone_number, :user_id, :item_id, :token

  with_options presence: true do
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: 'はハイフンを含めて入力してください' }
    validates :prefecture_id, numericality: { other_than: 0, message: 'を選択してください' }
    validates :city, message: 'は入力必須です'
    validates :address, message: 'は入力必須です'
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: 'は10桁以上11桁以内の半角数値で入力してください' }
    validates :token, message: 'クレジットカード情報を入力してください'
    validates :user_id, :item_id
  end

  def save
    ActiveRecord::Base.transaction do
      order = Order.create!(user_id:, item_id:)
      Address.create!(postal_code:, prefecture_id:, city:, address:, building:,
                      phone_number:, order_id: order.id)
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, "購入処理に失敗しました: #{e.message}")
    false
  end
end

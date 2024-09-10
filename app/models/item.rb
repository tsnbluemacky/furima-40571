# app/models/item.rb
class Item < ApplicationRecord
  has_one_attached :image
  has_one :order

  extend ActiveHash::Associations::ActiveRecordExtensions

  # 関連付け
  belongs_to :user
  belongs_to :shipping_fee
  belongs_to :category
  belongs_to :condition
  belongs_to :prefecture
  belongs_to :delivery_time

  # バリデーション
  with_options presence: true do
    validates :image
    validates :name
    validates :text
    validates :price, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 300,
      less_than_or_equal_to: 9_999_999
    }
    validates :shipping_fee_id, :category_id, :condition_id, :delivery_time_id,
              numericality: { other_than: 1 }
    validates :prefecture_id,
              numericality: { other_than: 0 }
  end

  # 商品が売れているかを判断するメソッド
  def sold_out?
    order.present?
  end
end

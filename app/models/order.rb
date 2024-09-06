# app/models/order.rb
class Order < ApplicationRecord
  attr_accessor :token

  belongs_to :user
  belongs_to :item

  validates :token, presence: true

  # 注文の合計金額を取得する
  def total_price
    item.price
  end
end

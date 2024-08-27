# app/models/item.rb
class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :condition
  belongs_to :shipping
  belongs_to :prefecture
  belongs_to :delivery_time

  belongs_to :user
  has_one_attached :image
  has_one :order

  # バリデーションの設定
  with_options presence: true do
    validates :image
    validates :name
    validates :text
    validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999 }
  end

  validates :category_id, :condition_id, :shipping_id, :prefecture_id, :delivery_time_id,
            numericality: { other_than: 1, message: "can't be blank" }
end

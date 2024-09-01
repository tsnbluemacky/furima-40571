class Item < ApplicationRecord
  has_one_attached :image # ActiveStorageで画像を管理
  has_one :order

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :shipping_fee

  extend ActiveHash::Associations::ActiveRecordExtensions

  # 関連付け
  belongs_to :user
  has_one_attached :image

  # カテゴリー、状態、配送料、発送元、発送までの日数の関連付け
  belongs_to :category
  belongs_to :condition
  belongs_to :shipping
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
      less_than_or_equal_to: 9_999_999,
      message: '販売可能価格外です'
    }
  end

  # ActiveHashのIDが1である場合のバリデーション
  validates :category_id, :condition_id, :shipping_id, :delivery_time_id,
            numericality: { other_than: 1, message: 'を選択してください' }
  validates :prefecture_id,
            numericality: { other_than: 0, message: 'を選択してください' }

  # 商品が売れているかを判断するメソッド
  def sold_out?
    order.present?
  end
  validates :shipping_fee_id, presence: true
end

class Item < ApplicationRecord
  has_one_attached :image # ActiveStorageで画像を管理
  has_one :order
  # その他のアソシエーションやバリデーション

  # 商品が売れているかを判断するメソッド（例）
  def sold_out?
    order.present?
  end
end

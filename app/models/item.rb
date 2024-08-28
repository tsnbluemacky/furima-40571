class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  # 関連付け
  belongs_to :user            # ユーザーとの関連付け
  has_one_attached :image     # 画像の添付（Active Storage）
  has_one :order              # 注文情報との関連付け

  belongs_to :category        # カテゴリー情報との関連付け
  belongs_to :condition       # 商品の状態情報との関連付け
  belongs_to :shipping        # 配送料情報との関連付け
  belongs_to :prefecture      # 発送元の地域情報との関連付け
  belongs_to :delivery_time   # 発送までの日数情報との関連付け

  # バリデーション
  with_options presence: true do
    validates :image                # 画像の添付が必須
    validates :name                 # 商品名の入力が必須
    validates :text                 # 商品の説明の入力が必須
    validates :price, numericality: {
      only_integer: true,            # 価格は整数であること
      greater_than_or_equal_to: 300, # 価格が300円以上であること
      less_than_or_equal_to: 9_999_999, # 価格が9,999,999円以下であること
      message: '販売可能価格外です' # エラーメッセージ
    }
  end

  # ActiveHashのIDが0である場合のバリデーション
  validates :category_id, :condition_id, :shipping_id, :prefecture_id, :delivery_time_id,
            numericality: { other_than: 0, message: 'を選択してください' } # IDが0以外であることをチェック
end

class Order < ApplicationRecord
  attr_accessor :token # トークンのアクセサを追加

  belongs_to :user
  belongs_to :item

  validates :token, presence: true # トークンの存在確認バリデーションを追加
end

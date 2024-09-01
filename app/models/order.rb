class Order < ApplicationRecord
  belongs_to :user
  belongs_to :item

  # コメントアウト
  # belongs_to :user
  # belongs_to :item
end

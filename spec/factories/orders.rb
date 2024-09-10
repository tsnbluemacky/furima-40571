FactoryBot.define do
  factory :order do
    token { 'tok_abcdefghijk00000000000000000' } # テスト用のトークン
    association :user # User モデルの関連付け
    association :item # Item モデルの関連付け
  end
end
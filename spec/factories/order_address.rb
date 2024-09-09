FactoryBot.define do
  factory :order_address do
    postal_code { '123-4567' }
    prefecture_id { 2 }
    city { '東京都' }
    address { '渋谷区神南1-1-1' }
    building_name { 'テストビル101' }
    phone_number { '09012345678' }
    token { 'tok_abcdefghijk00000000000000000' }

    association :user  # userを関連付ける
    association :item  # itemを関連付ける
  end
end

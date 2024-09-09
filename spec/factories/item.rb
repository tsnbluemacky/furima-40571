# spec/factories/items.rb
FactoryBot.define do
  factory :item do
    name { 'Test Item' }
    text { 'This is a test item.' }
    category_id { 2 }
    condition_id { 2 }
    shipping_fee_id { 2 }
    prefecture_id { 2 }
    delivery_time_id { 2 }
    price { 1000 }
    association :user

    # 画像の添付
    after(:build) do |item|
      item.image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png')), filename: 'test_image.png', content_type: 'image/png')
    end
  end
end

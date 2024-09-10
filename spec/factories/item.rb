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
    association :user  # userと関連付け
    after(:build) do |item|
      item.image.attach(io: File.open('public/images/f64084f8fde7075970b2bee612cfacc5.png'), filename: 'f64084f8fde7075970b2bee612cfacc5.png')
    end
  end
end

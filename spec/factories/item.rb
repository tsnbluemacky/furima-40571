# spec/factories/items.rb
FactoryBot.define do
  factory :item do
    name { 'Test Item' }
    text { 'This is a test item.' } # description -> text
    category_id { 2 }
    condition_id { 2 }
    shipping_id { 2 } # postage_payer_id -> shipping_id
    prefecture_id { 2 }
    delivery_time_id { 2 }
    price { 1000 }
    association :user

    after(:build) do |item|
      item.image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png')),
                        filename: 'test_image.png', content_type: 'image/png')
    end
  end
end

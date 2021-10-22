FactoryBot.define do
  factory :mock_item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    merchant
  end
end

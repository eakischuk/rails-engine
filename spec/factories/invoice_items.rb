FactoryBot.define do
  factory :mock_invoice_items do
    item
    invoice
    quantity { Faker::Number.between(from: 1, to: 25) }
    unit_price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end
end

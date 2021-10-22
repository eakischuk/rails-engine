FactoryBot.define do
  factory :mock_invoice do
    customer
    merchant
    status { "shipped" }
  end
end

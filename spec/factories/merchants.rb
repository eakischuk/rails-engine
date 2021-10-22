FactoryBot.define do
  factory :mock_merchant do
    name { Faker::Company.name }
  end
end

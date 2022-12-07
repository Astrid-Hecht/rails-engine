require 'faker'

FactoryBot.define do
  factory :item do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    unit_price {rand(1.0..100.5)}
    merchant
  end
end

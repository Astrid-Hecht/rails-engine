require 'faker'

FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { rand(0..2) }
  end
end
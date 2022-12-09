require 'faker'

FactoryBot.define do
  factory :invoice_item do
    item 
    invoice
    quantity { rand(1..100)}
    unit_price { rand(1.0..100.5) }
  end
end
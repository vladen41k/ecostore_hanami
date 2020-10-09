# frozen_string_literal: true

FactoryBot.define do
  factory :order_item do
    product
    order
    cost { product.cost }
    quantity { Faker::Number.number(digits: 1) }
    total_cost { cost * quantity }
    name { product.name }
  end
end

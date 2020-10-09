# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Device.model_name }
    cost { Faker::Number.number(digits: 3) }
    active { true }

    trait :with_category do
      after :create do |product|
        create_list :category, 3, product: product
      end
    end
  end
end

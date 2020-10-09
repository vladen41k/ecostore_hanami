# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    status { 0 }
    total_cost { Faker::Number.number(digits: 3) }
  end
end

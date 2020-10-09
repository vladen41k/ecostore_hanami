# frozen_string_literal: true
# _attributes, class: UserRepository
FactoryBot.define do
  faker_password = Faker::Internet.password
  factory :user_attributes, class: 'User' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { faker_password }
    password_confirmation { faker_password }
  end

  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password_digest { BCrypt::Password.create(Faker::Internet.password) }
    activated { true }
  end
end

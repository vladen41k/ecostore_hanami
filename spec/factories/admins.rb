# frozen_string_literal: true
# _attributes, class: UserRepository
FactoryBot.define do
  faker_password = Faker::Internet.password
  factory :admin_attributes, class: 'AdminUser' do
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { faker_password }
    password_confirmation { faker_password }
  end

  factory :admin, class: 'AdminUser' do
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    password_digest { BCrypt::Password.create(faker_password) }
    activated { true }
  end
end

source 'https://rubygems.org'

gem 'hanami',       '~> 1.3'
gem 'rake'
# gem 'hanami-model', '~> 1.3'
# fixes bigdecimal error
gem 'hanami-model', git: 'https://github.com/hanami/model.git'

gem 'pg'
# gem 'puma'

gem 'bcrypt'
gem 'dry-monads'
gem 'foreman'
gem 'jsonapi-serializer'
gem 'jwt'
gem 'sberbank-acquiring', '~> 1.0'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'whenever', require: false

group :development do
  # Code reloading
  # See: https://guides.hanamirb.org/projects/code-reloading
  gem 'hanami-webconsole'
  gem 'letter_opener'
  gem 'shotgun', platforms: :ruby
end

group :test, :development do
  gem 'byebug'
  gem 'dotenv', '~> 2.4'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'faker'
  gem 'rspec'
end

group :production do
  # gem 'puma'
end

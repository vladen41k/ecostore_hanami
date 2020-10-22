require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require_relative '../lib/ecostore_hanami'
require_relative '../apps/api/application'
require_relative './sidekiq'
require_relative '../apps/admin/application'

Hanami.configure do
  mount Admin::Application, at: '/admin'
  mount Api::Application, at: '/'

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/ecostore_hanami_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/ecostore_hanami_development'
    #    adapter :sql, 'mysql://localhost/ecostore_hanami_development'
    #
    adapter :sql, ENV.fetch('DATABASE_URL')

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  mailer do
    root 'lib/ecostore_hanami/mailers'

    # See https://guides.hanamirb.org/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: https://guides.hanamirb.org/projects/logging
    logger level: :debug

    mailer do
      delivery LetterOpener::DeliveryMethod, location: File.expand_path('../tmp/letter_opener', __FILE__)
    end

  end

  environment :production do
    logger level: :info, formatter: :json, filter: []

    mailer do
      delivery :smtp, address: ENV.fetch('SMTP_HOST'), port: ENV.fetch('SMTP_PORT')
    end
  end
end

# frozen_string_literal: true

class UpdateAdminValidation
  include Hanami::Validations

  messages_path 'config/errors.yml'

  validations do
    required(:id).filled(:int?)
    required(:admin).schema do
      optional(:full_name) { filled? & str? & size?(2..30) }
      optional(:email) { filled? & str? & size?(5..50) & format?(/@/) }

      validate(unique_email: %i[email]) do |email|
        AdminUserRepository.new.admin_users.where(email: email.downcase).to_a.blank?
      end
    end
  end
end

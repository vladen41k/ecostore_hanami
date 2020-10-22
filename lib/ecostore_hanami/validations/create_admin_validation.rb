# frozen_string_literal: true

class CreateAdminValidation
  include Hanami::Validations

  messages_path 'config/errors.yml'

  validations do
    required(:admin).schema do
      required(:full_name) { filled? & str? & size?(2..30) }
      required(:email) { filled? & str? & size?(5..50) & format?(/@/) }
      required(:password) { filled? & str? & size?(6..16) }
      required(:password_confirmation) { filled? & str? & size?(6..16) }
      optional(:activated).filled(:bool?)
      # optional(:activated) { filled? & (type?(TrueClass) || type?(FalseClass)) }

      validate(unique_email: %i[email]) do |email|
        AdminUserRepository.new.admin_users.where(email: email.downcase).to_a.blank?
      end

      validate(equal_passwords: %i[password password_confirmation]) { |p, p_c| p == p_c }
    end
  end
end

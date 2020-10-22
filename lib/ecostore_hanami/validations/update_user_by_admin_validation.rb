# frozen_string_literal: true

class UpdateUserByAdminValidation
  include Hanami::Validations

  messages_path 'config/errors.yml'

  validations do
    required(:id).filled(:int?)
    required(:user).schema do
      optional(:first_name) { filled? & str? & size?(2..16) }
      optional(:last_name) { filled? & str? & size?(2..16) }
      optional(:email) { filled? & str? & size?(5..50) & format?(/@/) }
      optional(:activated).filled(:bool?)
      # optional(:activated) { filled? & (type?(TrueClass) || type?(FalseClass)) }

      validate(unique_email: %i[email]) do |email|
        UserRepository.new.all_where(email: email.downcase).blank?
      end
    end
  end
end

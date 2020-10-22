# frozen_string_literal: true

class UpdateUserValidation
  include Hanami::Validations

  messages_path 'config/errors.yml'

  validations do
    required(:id).filled(:int?)
    required(:user).schema do
      optional(:first_name) { filled? & str? & size?(2..16) }
      optional(:last_name) { filled? & str? & size?(2..16) }
      optional(:email) { filled? & str? & size?(5..50) & format?(/@/) }
      required(:password) { filled? & str? & size?(6..16) }

      validate(unique_email: %i[email]) do |email|
        UserRepository.new.all_where(email: email.downcase).blank?
      end
    end

    validate(confirm_password_at_update: %i[id user]) do |id, u|
      user = UserRepository.new.find(id)
      user.present? ? BCrypt::Password.new(user.password_digest) == u[:password] : false
    end
  end
end

# frozen_string_literal: true

class UpdateUserPasswordValidation
  include Hanami::Validations

  messages_path 'config/errors.yml'

  validations do
    required(:id).filled(:int?)
    required(:user).schema do
      required(:new_password) { filled? & str? & size?(6..16) }
      required(:password) { filled? & str? & size?(6..16) }
      required(:password_confirmation) { filled? & str? & size?(6..16) }

      validate(equal_passwords: %i[password password_confirmation]) { |p, p_c| p == p_c }

      validate(unequal_passwords: %i[password new_confirmation]) { |p, n_p| p != n_p }

      validate(confirm_password_at_update: %i[id user]) do |id, u|
        user = UserRepository.new.find(id)
        user.present? ? BCrypt::Password.new(user.password_digest) == u[:password] : false
      end
    end
  end
end

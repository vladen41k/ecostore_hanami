# frozen_string_literal: true

class UpdateAdminPasswordValidation
  include Hanami::Validations

  messages_path 'config/errors.yml'

  validations do
    required(:id).filled(:int?)
    required(:admin).schema do
      required(:new_password) { filled? & str? & size?(6..16) }
      required(:password) { filled? & str? & size?(6..16) }
      required(:password_confirmation) { filled? & str? & size?(6..16) }

      validate(equal_passwords: %i[password password_confirmation]) { |p, p_c| p == p_c }

      validate(unequal_passwords: %i[password new_confirmation]) { |p, n_p| p != n_p }

      validate(confirm_password_at_update: %i[id admin]) do |id, a|
        admin = AdminUserRepository.new.find(id)
        admin.present? ? BCrypt::Password.new(admin.password_digest) == a[:password] : false
      end
    end
  end
end

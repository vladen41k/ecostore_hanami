class CreateUserValidation
  include Hanami::Validations

  messages_path 'config/errors.yml'

  validations do
    required(:user).schema do
      required(:first_name) { filled? & str? & size?(2..16) }
      required(:last_name) { filled? & str? & size?(2..16) }
      required(:email) { filled? & str? & size?(5..16) }
      required(:password) { filled? & str? & size?(6..16) }
      required(:password_confirmation) { filled? & str? & size?(6..16) }

      validate(unique_email: %i[email]) do |email|
        UserRepository.new.all_where(email: email.downcase).blank?
      end

      validate(equal_passwords: %i[password password_confirmation]) { |p, p_c| p == p_c }
    end
  end
end

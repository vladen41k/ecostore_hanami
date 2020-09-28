# frozen_string_literal: true
class CreateUserSessionValidation
  include Hanami::Validations
  validations do
    required(:user).schema do
      required(:email).filled(:str?)
      required(:password).filled(:str?)
    end
  end
end

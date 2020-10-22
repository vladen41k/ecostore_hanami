# frozen_string_literal: true
class CreateAdminSessionValidation
  include Hanami::Validations
  validations do
    required(:admin).schema do
      required(:email).filled(:str?)
      required(:password).filled(:str?)
    end
  end
end

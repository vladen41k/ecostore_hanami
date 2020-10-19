# frozen_string_literal: true

class OrderFormationValidation
  include Hanami::Validations

  validations do
    required(:id).filled(:int?)
  end
end

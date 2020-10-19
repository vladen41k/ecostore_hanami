# frozen_string_literal: true

class CreatePaymentValidation
  include Hanami::Validations

  PAYMENT_METHODS_LIST = %w[Sberbank].freeze

  validations do
    required(:id).filled(:int?)
    required(:payment_method).filled(:str?, included_in?: PAYMENT_METHODS_LIST)
  end
end

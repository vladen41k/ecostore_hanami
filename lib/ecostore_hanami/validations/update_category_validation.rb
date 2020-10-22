# frozen_string_literal: true

class UpdateCategoryValidation
  include Hanami::Validations

  validations do
    required(:id).filled(:int?)
    required(:category).schema do
      required(:name) { filled? & str? }
    end
  end
end

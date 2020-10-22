# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module CategoriesServices
  class UpdateCategoryService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def call(params)
      valid_params = yield validate(params)
      result = yield update_category(valid_params[:id], valid_params[:category])

      Success(result)
    end

    private

    def validate(params)
      res = UpdateCategoryValidation.new(params).validate

      res.success? ? Success(res) : Failure(res)
    end

    def update_category(id, category_params)
      Try do
        category = CategoryRepository.new.update(id, category_params)

        CategorySerializer.new(category).serializable_hash.to_json
      end.to_result
    end
  end
end

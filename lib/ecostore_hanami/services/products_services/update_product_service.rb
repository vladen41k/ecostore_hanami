# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module ProductsServices
  class UpdateProductService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def call(params)
      valid_params = yield validate(params)
      result = yield update_product(valid_params[:id], valid_params[:product])
      Success(result)
    end

    private

    def validate(params)
      res = UpdateProductValidation.new(params).validate

      if res.success?
        res[:product][:category_ids] = res[:product].delete(:category_ids).tr('^0-9,', '').split(',')

        Success(res)
      else
        Failure(res)
      end
    end

    def update_product(id, product_params)
      Try do
        category_ids = product_params.delete(:category_ids)
        product = ProductRepository.new.update(id, product_params)
        ProductRepository.new.update_category(id, category_ids)

        ProductSerializer.new(product).serializable_hash.to_json
      end.to_result
    end
  end
end

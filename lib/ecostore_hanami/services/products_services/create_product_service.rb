require 'dry/monads'
require 'dry/monads/do'

module ProductsServices
  class CreateProductService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def initialize
      @category_id_not_exist = []
    end

    def call(params)
      valid_params = yield validate(params)
      result = yield create_product(valid_params[:product])
      Success(result)
    end

    private

    def validate(params)
      res = CreateProductValidation.new(params).validate
      if res.success?
        res[:product][:category_ids] = res[:product].delete(:category_ids).tr('^0-9,', '').split(',')

        Success(res)
      else
        Failure(res)
      end
    end

    def create_product(product_params)
      Try do
        product = ProductRepository.new.create(product_params)
        product_params[:category_ids].each do |cat_id|
          CategoriesProductsRepository.new.create(category_id: cat_id, product_id: product.id)
        end

        ProductSerializer.new(product).serializable_hash.to_json
      end.to_result
    end
  end
end

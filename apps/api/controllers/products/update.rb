module Api
  module Controllers
    module Products
      class Update
        include Api::Action
        include ErrorsHelper

        def call(params)
          result = ProductsServices::UpdateProductService.new.call(params)

          result.success? ? status(200, result.success) : status(400, { data: errors_messages(result) }.to_json)
        end
      end
    end
  end
end

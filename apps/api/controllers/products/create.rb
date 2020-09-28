module Api
  module Controllers
    module Products
      class Create
        include Api::Action
        include ErrorsHelper
        include AuthenticateUserHelper

        def call(params)
          result = ProductsServices::CreateProductService.new.call(params)

          if result.success?
            self.body = result.success
            self.status = 201
          else
            self.body = { data: errors_messages(result) }.to_json
            self.status = 400
          end
        end

      end
    end
  end
end

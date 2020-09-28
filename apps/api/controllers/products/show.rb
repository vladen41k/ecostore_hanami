module Api
  module Controllers
    module Products
      class Show
        include Api::Action

        expose :product

        params do
          required(:id).filled(:int?)
        end

        def call(params)
          product = ProductRepository.new.find(params[:id])

          self.body = ProductSerializer.new(product).serializable_hash.to_json
          self.status = 200
        end
      end
    end
  end
end

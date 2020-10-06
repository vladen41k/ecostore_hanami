module Api
  module Controllers
    module Products
      class Index
        include Api::Action

        def call(_)
          @products = ProductRepository.new.all_with__categories
          self.status = 200
          self.body = ProductSerializer.new(@products).serializable_hash.to_json
        end
      end
    end
  end
end

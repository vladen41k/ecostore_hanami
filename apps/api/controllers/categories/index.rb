module Api
  module Controllers
    module Categories
      class Index
        include Api::Action

        def call(_)
          products = CategoryRepository.new.all
          self.status = 200
          self.body = CategorySerializer.new(products).serializable_hash.to_json
        end
      end
    end
  end
end

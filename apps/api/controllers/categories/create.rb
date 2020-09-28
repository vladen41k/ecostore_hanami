module Api
  module Controllers
    module Categories
      class Create
        include Api::Action

        expose :category

        params do
          required(:category).schema do
            required(:name).filled(:str?)
          end
        end

        def call(params)
          if params.valid?
            product = CategoryRepository.new.create(params[:category])

            self.body = CategorySerializer.new(product).serializable_hash.to_json
            self.status = 201
          else
            self.body = params.errors.to_json
            self.status = 400
          end
        end
      end
    end
  end
end

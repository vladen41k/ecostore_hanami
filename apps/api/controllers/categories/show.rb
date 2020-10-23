module Api
  module Controllers
    module Categories
      class Show
        include Api::Action
        include Helpers::ErrorsHelper

        params do
          required(:id).filled(:int?)
        end

        def call(params)
          if params.valid?
            product = CategoryRepository.new.find params[:id]

            status 200, CategorySerializer.new(product).serializable_hash.to_json
          else
            status 400, { data: errors_messages(params) }.to_json
          end
        end
      end
    end
  end
end

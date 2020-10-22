# frozen_string_literal: true

module Admin
  module Controllers
    module Categories
      class Show
        include Admin::Action

        params do
          required(:id).filled(:str?)
        end

        def call(params)
          if current_admin
            if params.valid?
              product = CategoryRepository.new.find params[:id]

              status 200, CategorySerializer.new(product).serializable_hash.to_json
            else
              status 400, params.errors.to_json
            end
          else
            status 400, { data: current_admin_errors }.to_json
          end
        end
      end
    end
  end
end

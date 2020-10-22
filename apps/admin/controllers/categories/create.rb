# frozen_string_literal: true

module Admin
  module Controllers
    module Categories
      class Create
        include Admin::Action
        include Admin::Controllers::AuthenticateAdminHelper

        params do
          required(:category).schema do
            required(:name).filled(:str?)
          end
        end

        def call(params)
          if current_admin
            if params.valid?
              product = CategoryRepository.new.create(params[:category])

              self.body = CategorySerializer.new(product).serializable_hash.to_json
              self.status = 201
            else
              self.body = params.errors.to_json
              self.status = 400
            end
          else
            status 400, { data: current_admin_errors }.to_json
          end
        end
      end
    end
  end
end

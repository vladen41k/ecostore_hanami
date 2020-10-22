# frozen_string_literal: true

module Admin
  module Controllers
    module Products
      class Show
        include Admin::Action
        include Admin::Controllers::AuthenticateAdminHelper

        expose :product

        params do
          required(:id).filled(:int?)
        end

        def call(params)
          if current_admin
            product = ProductRepository.new.find(params[:id])

            status 200, ProductSerializer.new(product).serializable_hash.to_json
          else
            status 400, { data: current_admin_errors }.to_json
          end
        end
      end
    end
  end
end

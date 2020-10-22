# frozen_string_literal: true

module Admin
  module Controllers
    module Products
      class Create
        include Admin::Action
        include Helpers::ErrorsHelper
        include Admin::Controllers::AuthenticateAdminHelper

        def call(params)
          if current_admin
            result = ProductsServices::CreateProductService.new.call(params)

            result.success? ? status(201, result.success) : status(400, { data: errors_messages(result) }.to_json)
          else
            status 400, { data: current_admin_errors }.to_json
          end
        end

      end
    end
  end
end

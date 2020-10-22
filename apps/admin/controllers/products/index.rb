# frozen_string_literal: true

module Admin
  module Controllers
    module Products
      class Index
        include Admin::Action
        include Admin::Controllers::AuthenticateAdminHelper

        def call(_)
          if current_admin
            @products = ProductRepository.new.all_with__categories
            self.status = 200
            self.body = ProductSerializer.new(@products).serializable_hash.to_json
          else
            status 400, { data: current_admin_errors }.to_json
          end
        end
      end
    end
  end
end

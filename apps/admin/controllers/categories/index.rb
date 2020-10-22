# frozen_string_literal: true

module Admin
  module Controllers
    module Categories
      class Index
        include Admin::Action
        include Admin::Controllers::AuthenticateAdminHelper

        def call(_)
          if current_admin
            products = CategoryRepository.new.all
            self.status = 200
            self.body = CategorySerializer.new(products).serializable_hash.to_json
          else
            status 400, { data: current_admin_errors }.to_json
          end
        end
      end
    end
  end
end

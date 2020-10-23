# frozen_string_literal: true

module Admin
  module Controllers
    module Orders
      class Index
        include Admin::Action
        include Admin::Controllers::AuthenticateAdminHelper

        def call(_)
          if current_admin
            orders = OrderRepository.new.all_items_order
            self.status = 200
            self.body = OrderSerializer.new(orders).serializable_hash.to_json
          else
            status 400, { data: current_admin_errors }.to_json
          end
        end
      end
    end
  end
end

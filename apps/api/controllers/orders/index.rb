# frozen_string_literal: true

module Api
  module Controllers
    module Orders
      class Index
        include Api::Action
        include AuthenticateUserHelper

        def call(_)
          if current_user
            orders = OrderRepository.new.where_with_order_items(user_id: current_user.id).to_a
            self.status = 200
            self.body = OrderSerializer.new(orders).serializable_hash.to_json
          else
            status 400, { data: { user: 'must be authenticated' } }.to_json
          end
        end
      end
    end
  end
end

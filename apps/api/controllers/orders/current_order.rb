# frozen_string_literal: true

module Api
  module Controllers
    module Orders
      class Show
        include Api::Action
        include AuthenticateUserHelper

        def call(_)
          if current_user
            statuses = [Orders.status(:cart), Orders.status(:payment_awaiting)]
            orders = OrderRepository.new.orders.where("status in (#{statuses}) and user_id = #{current_user.id}").first

            status 200, OrderSerializer.new(orders).serializable_hash.to_json
          else
            status 400, { data: { user: 'must be authenticated' } }.to_json
          end
        end
      end
    end
  end
end

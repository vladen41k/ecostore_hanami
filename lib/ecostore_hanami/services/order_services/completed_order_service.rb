# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module OrderServices
  # id is order id
  class CompletedOrderService
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)

    def call(id)
      order = yield completed_order(id)

      Success(OrderSerializer.new(order).serializable_hash.to_json)
    end

    private

    def completed_order(id)
      order = OrderRepository.new.find(id)
      Failure({ order: 'order not found' }) if order.blank?

      if order.status == Order.status(:paid)
        Try do
          OrderRepository.new.update(id, status: Order.status(:completed))
        end.to_result
      else
        Failure({ order: 'order not be completed' })
      end
    end
  end
end

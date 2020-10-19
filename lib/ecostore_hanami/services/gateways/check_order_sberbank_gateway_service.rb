# frozen_string_literal: true

module Gateways
  class CheckOrderSberbankGatewayService

    def call(order)
      order_status = check_payment(order)
      if order_status == 2
        OrderRepository.new.update(order.id, status: Order.status(:paid))
        PaymentRepository.new.update(order.payment.id, status: Payment.status(:completed))
      else
        OrderRepository.new.update(order.id, status: Order.status(:cart))
        PaymentRepository.new.delete(order.payment.id)
      end
    end

    private

    def check_payment(order)
      client = if Hanami.env == 'production'
                 SBRF::Acquiring::Client.new(username: ENV['SBER_USERNAME'], password: ENV['SBER_PASSWORD'])
               else
                 SBRF::Acquiring::Client.new(token: ENV['SBER_TOKEN'], test: true)
               end
      response = client.get_order_status_extended(order_id: order.payment.order_token)

      response.order_status
    end

  end
end

# frozen_string_literal: true

module OrderServices
  class CheckOrderForPaymentService
    def call
      orders = find_orders
      return true if orders.blank?

      check_orders(orders)
    end

    private

    def find_orders
      OrderRepository.new.where_with_payment("status = #{Order.status(:payment_awaiting)} AND
                                            (updated_at + INTERVAL '20 MINUTE') < (NOW() AT TIME ZONE 'utc')")
    end

    def check_orders(orders)
      orders.each do |order|
        if order.payment.present?
          payment_method = PaymentMethodRepository.new.find(order.payment.payment_method_id)

          ('Gateways::CheckOrder' + payment_method.gateway).constantize.new.call(order)
        else
          OrderRepository.new.update(order.id, status: Order.status(:cart))
        end
      end
    end
  end
end

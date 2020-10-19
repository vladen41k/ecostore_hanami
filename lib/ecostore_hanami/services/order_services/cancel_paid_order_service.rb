# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module OrderServices
  class CancelPaidOrderService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def call(order)
      status = yield check_order_status(order)
      order = order.first

      result = if status == :paid
                 yield cancel_paid(order, status)
               elsif status == :payment_awaiting
                 yield order_id_payment_awaiting(order, status)
               else
                 Failure({ order: 'order not be canceled' })
               end

      Success(result)
    end

    private

    def check_order_status(order)
      Failure({ order: 'order not found' }) if order.blank?

      Success(Order.status(order.first.status))
    end

    def cancel_paid(order, status)
      payment_method = PaymentMethodRepository.new.find(order.payment.payment_method_id)

      ('Gateways::Canceled' + payment_method.gateway).constantize.new.call(order, status)
    end

    def order_id_payment_awaiting(order, status)
      if order.payment.present?
        cancel_paid(order, status)
      else
        Try do
          OrderRepository.new.update(order.id, status: Order.status(:cart))
        end.to_result
      end
    end

  end
end

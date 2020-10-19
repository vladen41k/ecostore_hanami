# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Gateways
  class SberbankGatewayService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def call(order_id, user, payment_method)
      order = yield find_order(user.id, order_id)
      sber_response = yield create_payment_in_sber(order)
      result = yield create_payment(sber_response, order, payment_method)

      Success(result)
    end

    private

    def find_order(user_id, order_id)
      order = OrderRepository.new.orders.where(id: order_id, user_id: user_id,
                                               status: Order.status(:payment_awaiting)).one

      order.present? ? Success(order) : Failure({ order: 'order not found' })
    end

    def create_payment_in_sber(order)
      Try do
        client = if Hanami.env == 'production'
                   SBRF::Acquiring::Client.new(username: ENV['SBER_USERNAME'], password: ENV['SBER_PASSWORD'])
                 else
                   SBRF::Acquiring::Client.new(token: ENV['SBER_TOKEN'], test: true)
                 end

        payment_params = { amount: order.total_cost, order_number: order.id }

        client.register(payment_params)
      end.to_result
    end

    def create_payment(sber_response, order, payment_method)
      payment = PaymentRepository.new.where(order_id: order.id).one
      if sber_response.success?
        params = { order_token: sber_response.order_id, payment_url: sber_response.form_url, error_message: nil,
                   payment_method_id: payment_method.id }
        payment.present? ? update_payment(payment.id, params) : create_new_payment(params.merge(order_id: order.id))
        OrderRepository.new.update(order.id, status: Order.status(:payment_awaiting))

        Success({ data: { url: sber_response.form_url } }.to_json)
      else
        params = { status: Payment.status(:failed), error_message: sber_response.data['errorMessage'],
                   payment_method_id: payment_method.id }
        payment.present? ? update_payment(payment.id, params) : create_new_payment(params.merge(order_id: order.id))

        Failure({ payment: sber_response.data['errorMessage'] })
      end
    end

    def create_new_payment(params)
      PaymentRepository.new.create(params)
    end

    def update_payment(id, params)
      PaymentRepository.new.update(id, params)
    end
  end
end

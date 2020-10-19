# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module OrderServices
  class CanceledSberbankGatewayService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def call(order, status)
      result = status == :paid ? (yield order_is_paid(order)) : (yield order_is_payment_awaiting(order))

      Success(result)
    end

    private

    def client
      @client ||= if Hanami.env == 'production'
                    SBRF::Acquiring::Client.new(username: ENV['SBER_USERNAME'], password: ENV['SBER_PASSWORD'])
                  else
                    SBRF::Acquiring::Client.new(token: ENV['SBER_TOKEN'], test: true)
                  end
    end

    def order_is_paid(order)
      response = client.refund({ order_id: order.payment.order_token })
      if response.success?
        Try do
          PaymentRepository.new.update(order.payment.id, Payment.status(:refunded))

          OrderRepository.new.update(order.id, status: Order.status(:canceled))
        end.to_result
      else
        Failure(response)
      end
    end

    # orderStatus
    # 0 - заказ зарегистрирован, но не оплачен;
    # 1 - предавторизованная сумма удержана (для двухстадийных платежей);
    # 2 - проведена полная авторизация суммы заказа;
    # 3 - авторизация отменена;
    # 4 - по транзакции была проведена операция возврата;
    # 5 - инициирована авторизация через сервер контроля доступа банка-эмитента;
    # 6 - авторизация отклонена.

    def order_is_payment_awaiting(order)
      response = client.get_order_status_extended(order_id: order.payment.order_token)
      if response.success?

        if response.order_status == 0
          Try do
            PaymentRepository.new.delete(order.payment.id)

            OrderRepository.new.update(order.id, status: Order.status(:cart))
          end.to_result
        elsif response.order_status == 2
          order_is_paid(order)
        else
          Failure({ order: 'order not be canceled or has been canceled' })
        end
      else
        Failure(response)
      end
    end
  end
end

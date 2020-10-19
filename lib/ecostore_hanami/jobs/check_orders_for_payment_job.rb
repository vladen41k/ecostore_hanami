# frozen_string_literal: true

# This job check orders for payment
# Order must have status :payment_awaiting.
class CheckOrdersForPaymentJob
  include Sidekiq::Worker

  def perform
    OrderServices::CheckOrderForPaymentService.new.call
  end
end

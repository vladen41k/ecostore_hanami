# frozen_string_literal: true

module Api
  module Controllers
    module Payments
      class Create
        include Api::Action
        include Helpers::ErrorsHelper
        include AuthenticateUserHelper

        def call(params)
          if current_user
            valid_params = CreatePaymentValidation.new(params).validate
            if valid_params.success?
              create_payment(valid_params, current_user)
            else
              status(400, { data: errors_messages(valid_params) }.to_json)
            end
          else
            status 400, { data: { user: 'must be authenticated' } }.to_json
          end
        end

        def create_payment(valid_params, current_user)
          order_id = valid_params[:id]
          payment_method = PaymentMethodRepository.new.payment_methods
                                                  .where(name: valid_params[:payment_method]).one
          result = ('Gateways::' + payment_method.gateway).constantize.new.call(order_id, current_user, payment_method)

          result.success? ? status(201, result.success) : status(400, { data: errors_messages(result) }.to_json)
        end
      end
    end
  end
end

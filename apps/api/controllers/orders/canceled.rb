# frozen_string_literal: true

module Api
  module Controllers
    module Orders
      class Canceled
        include Api::Action
        include Helpers::ErrorsHelper
        include AuthenticateUserHelper

        def call(params)
          if current_user
            valid_params = CanceledPaymentValidation.new(params).validate
            if valid_params.success?
              canceled_payment(valid_params, current_user)
            else
              status(400, { data: errors_messages(valid_params) }.to_json)
            end
          else
            status 400, { data: { user: 'must be authenticated' } }.to_json
          end
        end

        def canceled_payment(valid_params, current_user)
          order = OrderRepository.new.where_with_payment(id: valid_params[:id], user_id: current_user.id)
          result = ('Gateways::Canceled' + payment_method.gateway).constantize.new.call(order)

          result.success? ? status(201, result.success) : status(400, { data: errors_messages(result) }.to_json)
        end
      end
    end
  end
end

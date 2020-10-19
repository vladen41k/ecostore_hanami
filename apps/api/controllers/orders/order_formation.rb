# frozen_string_literal: true

module Api
  module Controllers
    module Orders
      class OrderFormation
        include Api::Action
        include ErrorsHelper
        include AuthenticateUserHelper

        def call(params)
          if current_user
            result = OrderServices::OrderFormationService.new.call(params, current_user)

            result.success? ? status(201, result.success) : status(400, { data: errors_messages(result) }.to_json)
          else
            status 400, { data: { user: 'must be authenticated' } }.to_json
          end
        end

      end
    end
  end
end

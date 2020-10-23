# frozen_string_literal: true

module Admin
  module Controllers
    module Orders
      class Completed
        include Admin::Action
        include Helpers::ErrorsHelper
        include Admin::Controllers::AuthenticateAdminHelper

        params do
          required(:order).schema do
            required(:id).filled(:int?)
          end
        end

        def call(params)
          if current_admin
            if params.valid?
              completed_order(params[:id])
            else
              status(400, { data: errors_messages(params) }.to_json)
            end
          else
            status 400, { data: current_admin_errors }.to_json
          end
        end

        private

        def completed_order(id)
          result = OrderServices::CompletedOrderService.new.call id

          result.success? ? status(201, result.success) : status(400, { data: errors_messages(result) }.to_json)
        end
      end
    end
  end
end

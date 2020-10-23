# frozen_string_literal: true

module Api
  module Controllers
    module Orders
      class Show
        include Api::Action
        include AuthenticateUserHelper
        include Helpers::ErrorsHelper

        params do
          required(:id).filled(:int?)
        end

        def call(params)
          if current_user
            show_order(params)
          else
            status 400, { data: { user: 'must be authenticated' } }.to_json
          end
        end

        def show_order(params)
          if params.valid?
            order = OrderRepository.new.where_with_order_items(id: params[:id],user_id: current_user.id).first

            status 200, OrderSerializer.new(order).serializable_hash.to_json
          else
            status 400, { data: errors_messages(params) }.to_json
          end
        end
      end
    end
  end
end

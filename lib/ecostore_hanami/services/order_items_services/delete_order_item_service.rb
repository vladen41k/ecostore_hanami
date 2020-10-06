# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module OrderItemsServices
  class DeleteOrderItemService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def call(params, user)
      valid_params = yield validate(params)
      result = yield delete_order_item(valid_params[:id], valid_params[:order_item][:quantity], user)

      Success(result)
    end

    private

    def validate(params)
      res = DeleteOrderItemValidation.new(params).validate

      res.success? ? Success(res) : Failure(res)
    end

    def delete_order_item(id, quantity, user)
      Try do
        order = OrderRepository.new.where_with_order_items(user_id: user.id, status: Order.status(:cart)).try(:first)

        if order.present?
          order_item = order.order_items.map { |i| i if i.id == id }
          if order_item.any? && order_item.first.quantity == quantity
            new_total_cost = new_total_cost(order, id)
            OrderItemRepository.delete id
            updated_order = OrderRepository.new.update(order.id, total_cost: new_total_cost)

            OrderSerializer.new(updated_order).serializable_hash.to_json
          elsif order_item.any?
            order_item = order_item.first
            new_quantity = order_item.quantity - quantity
            total_cost = order_item.cost * new_quantity
            new_total_cost = new_total_cost(order, id) + total_cost

            OrderItemRepository.new.update(order_item.id, total_cost: total_cost, quantity: new_quantity)
            updated_order = OrderRepository.new.update(order.id, total_cost: new_total_cost)

            OrderSerializer.new(updated_order).serializable_hash.to_json
          else
            Failure({ product: 'product in order not found' })
          end
        else
          Failure({ product: 'product in order not found' })
        end
      end.to_result
    end

    def new_total_cost(order, id)
      new_total_cost = order.order_items.map { |i| i.total_cost if i.id != id }

      new_total_cost.any? ? new_total_cost.inject(:+) : 0
    end
  end
end

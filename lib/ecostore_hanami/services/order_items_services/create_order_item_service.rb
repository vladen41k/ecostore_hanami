# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module OrderItemsServices
  # params = { order_item: { product_id: int, quantity: int } }
  class CreateOrderItemService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def call(params, user)
      valid_params = yield validate(params)
      result = yield create_product(valid_params[:product], user)

      Success(result)
    end

    private

    def validate(params)
      res = CreateOrderItemValidation.new(params).validate

      res.success? ? Success(res) : Failure(res)
    end

    def create_order_item(product_params, user)
      Try do
        product_cost = ProductRepository.new.products.select(:cost).where(id: product_params[:product_id]).one.cost
        order = OrderRepository.new.where_with_order_items(user_id: user.id, status: Order.status(:cart)).try(:first)
        new_product_params = { product_id: product_params[:product_id],
                               quantity: product_params[:quantity], cost: product_cost,
                               total_cost: product_cost * product_params[:quantity] }

        res = if order.present?
                order_item_product = order.order_items.map { |i| i if i.product_id == product_params[:product_id] }

                if order_item_product.any?
                  quantity = order_item_product[0].quantity + product_params[:quantity]
                  params = { quantity: quantity, cost: product_cost, total_cost: (product_cost * quantity) }
                  order_items = OrderItemRepository.new.update(order_item_product[0].id, params)
                  arr = OrderItemRepository.new.order_items.select(:total_cost).where(order_id: order.id).to_a
                  OrderRepository.new.update(order.id, total_cost: arr.map(&:total_cost).inject(:+))
                else
                  order_items = OrderItemRepository.new.create(new_product_params.merge(order_id: order.id))
                  OrderRepository.new.update(order.id,
                                             total_cost: (order.total_cost + new_product_params[:total_cost]))
                end
                order_items
              else
                params = { user_id: user.id, total_cost: new_product_params[:total_cost],
                           order_items: [new_product_params] }

                OrderRepository.new.create_with_order_items(params).order_items.first
              end

        CreateOrderItemSerializer.new(res).serializable_hash.to_json
      end.to_result
    end
  end
end

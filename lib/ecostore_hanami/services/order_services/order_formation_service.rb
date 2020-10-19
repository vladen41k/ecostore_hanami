# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module OrderServices
  # id is order id
  # params = { id: int }
  class OrderFormationService
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)

    def call(params, user)
      valid_params = yield validate(params)
      order = yield find_order(valid_params[:id], user.id)
      yield checking_product_changes(order)
      order = yield find_order(valid_params[:id], user.id)
      order = yield update_order_status(order)

      Success(OrderSerializer.new(order).serializable_hash.to_json)
    end

    private

    def validate(params)
      res = OrderFormationValidation.new(params).validate

      res.success? ? Success(res) : Failure(res)
    end

    def find_order(order_id, user_id)
      order = OrderRepository.new.where_with_order_items(id: order_id, user_id: user_id,
                                                         status: Order.status(:cart))[0]

      order.present? ? Success(order) : Failure({ order: 'order not found' })
    end

    def checking_product_changes(order)
      order_items = order.order_items
      Failure({ order: 'order is blank' }) if order_items.blank?

      ids = order_items.map(&:id)
      products = ProductRepository.new.products.where(id: ids).to_a
      order_items.each do |item|
        products.each do |product|
          next if item.product_id != product.id

          if product.active == false
            OrderItemRepository.new.delete(item.id)
            OrderRepository.new.update(order.id, total_cost: order.total_cost - item.total_cost)
          elsif item.cost != product.cost
            OrderItemRepository.new.update(item.id, cost: product.cost,
                                                    total_cost: (item.quantity * product.cost))
            total_cost = (order.total_cost - item.total_cost) + (item.quantity * product.cost)
            OrderRepository.new.update(order.id, total_cost: total_cost)
          end

          break
        end
      end
    end

    def update_order_status(order)
      if order.order_items.present?
        OrderRepository.new.update(order.id, status: Order.status(:payment_awaiting))

        OrderRepository.new.where_with_order_items(id: order.id)[0]
      else
        order
      end
    end
  end
end

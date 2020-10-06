# frozen_string_literal: true

class OrderSerializer
  include JSONAPI::Serializer

  attributes :description, :total_cost

  attribute(:status) { |order| Order.status(order.status) }

  attribute(:order_items) { |order| CreateOrderItemSerializer.new(order.order_items).serializable_hash }
end

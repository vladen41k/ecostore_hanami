class CreateOrderItemSerializer
  include JSONAPI::Serializer
  attributes :name, :cost, :total_cost, :quantity
end

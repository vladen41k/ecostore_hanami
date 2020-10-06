class OrderItemRepository < Hanami::Repository
  associations do
    belongs_to :order
    belongs_to :product
  end

  def find_with_order(id)
    aggregate(:order).where(id: id).map_to(Order).one
  end
end

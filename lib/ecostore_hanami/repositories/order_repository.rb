class OrderRepository < Hanami::Repository
  associations do
    belongs_to :user
    has_many :order_items
    has_one :payment
  end

  def all_items_order
    aggregate(:order_items)
  end

  def create_with_order_items(data)
    assoc(:order_items).create(data)
  end

  def where_with_order_items(hash)
    aggregate(:order_items).where(hash).map_to(Order).to_a
  end

  def where_with_payment(hash)
    aggregate(:payment).where(hash).map_to(Order).to_a
  end

  def find_with_payment(id)
    aggregate(:payment).where(id: id).map_to(Order).one
  end

  def order_items_order(id)
    aggregate(:order_items).where(id: id).map_to(Order).one
  end
end

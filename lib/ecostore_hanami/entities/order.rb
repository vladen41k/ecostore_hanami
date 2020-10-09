class Order < Hanami::Entity
  STATUSES = { 0 => :cart, 1 => :payment_awaiting, 2 => :paid, 3 => :canceled }.freeze

  def self.status(status_name)
    return STATUSES[status_name] if status_name.is_a?(Integer)

    STATUSES.key(status_name)
  end
end

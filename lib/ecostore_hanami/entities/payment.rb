# frozen_string_literal: true

class Payment < Hanami::Entity
  STATUS = { 0 => :new_payment, 1 => :payment_awaiting, 3 => :completed, 4 => :failed, 5 => :refunded }.freeze

  def self.status(status_name)
    return STATUSES[status_name] if status_name.is_a?(Integer)

    STATUSES.key(status_name)
  end
end

class PaymentRepository < Hanami::Repository
  associations do
    belongs_to :order
    belongs_to :payment_methods
  end
end

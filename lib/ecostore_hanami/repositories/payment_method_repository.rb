class PaymentMethodRepository < Hanami::Repository
  associations do
    has_many :payment_methods
  end
end

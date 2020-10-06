class CreateOrderItemValidation
  include Hanami::Validations

  validations do
    required(:order_item).schema do
      required(:product_id).filled(:int?)
      required(:quantity).filled(:int?)
    end
  end

end

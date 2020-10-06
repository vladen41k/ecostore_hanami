class DeleteOrderItemValidation
  include Hanami::Validations

  validations do
    required(:id).filled(:int?)
    required(:order_item).schema do
      required(:quantity).filled(:int?)
    end
  end
end

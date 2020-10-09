class CreateOrderItemValidation
  include Hanami::Validations

  messages_path 'config/errors.yml'

  validations do
    required(:order_item).schema do
      required(:product_id).filled(:int?)
      required(:quantity).filled(:int?)

      validate(product: %i[product_id]) do |id|
        ProductRepository.new.products.where(id: id, active: true).one.present?
      end
    end
  end

end

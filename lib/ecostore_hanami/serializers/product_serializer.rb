class ProductSerializer
  include JSONAPI::Serializer
  attributes :name

  attribute :categories do |product|
    ProductRepository.new.product_categories(product.id).to_h[:categories]
  end
end

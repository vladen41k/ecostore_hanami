class ProductSerializer
  include JSONAPI::Serializer
  attributes :name

  attribute :categories do |product|
    CategorySerializer.new(product.categories).serializable_hash
  end
end

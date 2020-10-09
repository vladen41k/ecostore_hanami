class CategoryRepository < Hanami::Repository
  associations do
    has_many :products
    has_many :products, through: :category_products
  end

  def category_to_product(id)
    categories.join(:products).where(products[:id] == id)
  end

  def find_with_products(id)
    aggregate(:products).where(id: id).map_to(Category).one
  end

  def all_where(hash)
    categories.where(hash).to_a
  end
end

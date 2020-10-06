class ProductRepository < Hanami::Repository
  associations do
    has_many :categories
    has_many :categories, through: :categories_products
  end

  def all_with__categories
    aggregate(:categories).to_a
  end

  def find_with_categories(id)
    aggregate(:categories).where(id: id).map_to(Product).one
  end

  def product_categories(id)
    aggregate(:categories).where(id: id).one
  end

  def update_with_category
    products.read("SELECT * FROM categories")
  end

  def update_category(product_id, categories_ids)
    str = categories_ids.each_with_object('').with_index do |(id, s), index|
      s << "#{', ' unless index.zero?}(#{product_id}, #{id})"
    end

    categories_products
        .read("DELETE FROM categories_products WHERE product_id = #{product_id};
             INSERT INTO categories_products (product_id, category_id)
             VALUES #{str};").one
  end
end

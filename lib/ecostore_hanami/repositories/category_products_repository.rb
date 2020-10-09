class CategoryProductsRepository < Hanami::Repository
  associations do
    belongs_to :category
    belongs_to :product
  end

  def update_category(product_id, categories_ids)
    categories = categories_ids.split(',')
    str = categories.each_with_object('').with_index do |(id, s), index|
      s << "#{', ' unless index.zero?}(#{product_id}, #{id})"
    end

    category_products
      .read("DELETE FROM category_products WHERE product_id = #{product_id};
             INSERT INTO category_products (product_id, category_id)
             VALUES #{str};")
  end
end

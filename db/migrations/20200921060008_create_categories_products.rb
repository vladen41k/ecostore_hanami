Hanami::Model.migration do
  change do
    create_table :categories_products do
      primary_key :id

      foreign_key :product_id, :products, null: false
      foreign_key :category_id, :categories, null: false

      column :created_at, DateTime, default: Time.now, null: false
      column :updated_at, DateTime, default: Time.now, null: false
    end
  end
end

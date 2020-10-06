Hanami::Model.migration do
  change do
    create_table :order_items do
      primary_key :id

      foreign_key :product_id, :products
      foreign_key :order_id, :products, null: false

      column :quantity, Integer
      column :cost, Integer
      column :total_cost, Integer
      column :name, String

      column :created_at, DateTime, default: Time.now, null: false
      column :updated_at, DateTime, default: Time.now, null: false
    end
  end
end

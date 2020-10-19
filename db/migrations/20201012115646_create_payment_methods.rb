Hanami::Model.migration do
  change do
    create_table :payment_methods do
      primary_key :id

      column :name, String, null: false
      column :gateway, String, null: false
      column :active, TrueClass, default: true, null: false

      column :created_at, DateTime, default: Time.now, null: false
      column :updated_at, DateTime, default: Time.now, null: false
    end
  end
end

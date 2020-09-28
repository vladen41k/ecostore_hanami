Hanami::Model.migration do
  change do
    create_table :categories do
      primary_key :id
      column :name, String, null: false

      column :created_at, DateTime, default: Time.now, null: false
      column :updated_at, DateTime, default: Time.now, null: false
    end
  end
end

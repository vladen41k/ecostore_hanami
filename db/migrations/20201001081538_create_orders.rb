Hanami::Model.migration do
  change do
    create_table :orders do
      primary_key :id

      foreign_key :user_id, :users, on_delete: :cascade, null: false

      column :description, String
      column :status, Integer, default: 0, null: false
      column :total_cost, Integer

      column :created_at, DateTime, default: Time.now, null: false
      column :updated_at, DateTime, default: Time.now, null: false
    end
  end
end

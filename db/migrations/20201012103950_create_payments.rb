# frozen_string_literal: true

Hanami::Model.migration do
  change do
    create_table :payments do
      primary_key :id

      foreign_key :order_id, :orders, null: false
      column :status, Integer, default: 0, null: false

      column :order_token, String
      column :payment_url, String
      column :error_message, String

      column :created_at, DateTime, default: Time.now, null: false
      column :updated_at, DateTime, default: Time.now, null: false
    end
  end
end

# frozen_string_literal: true

Hanami::Model.migration do
  change do
    create_table :admin_users do
      primary_key :id

      column :full_name, String, null: false
      column :email, String, null: false
      column :password_digest, String, null: false
      column :activated, TrueClass, default: true, null: false
      column :super_admin, TrueClass, default: false, null: false
      column :current_sign_in_at, DateTime
      column :last_sign_in_at, DateTime

      column :created_at, DateTime, default: Time.now, null: false
      column :updated_at, DateTime, default: Time.now, null: false
    end
  end
end

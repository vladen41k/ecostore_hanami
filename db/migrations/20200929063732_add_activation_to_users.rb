Hanami::Model.migration do
  change do
    alter_table :users do
      add_column :activated, TrueClass, null: false, default: false
      add_column :activation_digest, String
      add_column :activated_at, DateTime
      add_column :current_sign_in_at, DateTime
      add_column :last_sign_in_at, DateTime
    end
  end
end

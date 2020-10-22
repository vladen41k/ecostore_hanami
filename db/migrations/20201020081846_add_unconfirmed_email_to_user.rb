Hanami::Model.migration do
  change do
    alter_table :users do
      add_column :unconfirmed_email, String
    end
  end
end

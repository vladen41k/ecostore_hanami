Hanami::Model.migration do
  change do
    alter_table :payments do
      add_foreign_key :payment_method_id, :payment_methods
    end
  end
end

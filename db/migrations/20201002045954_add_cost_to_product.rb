Hanami::Model.migration do
  change do
    alter_table :products do
      add_column :cost, Integer
      add_column :active, Integer, null: false, default: 0
    end
  end
end

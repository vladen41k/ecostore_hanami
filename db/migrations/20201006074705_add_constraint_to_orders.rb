Hanami::Model.migration do
  change do
    alter_table :orders do
      set_column_default :total_cost, 0
      set_column_not_null :total_cost
    end
  end
end

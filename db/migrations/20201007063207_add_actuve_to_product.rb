# frozen_string_literal: true

Hanami::Model.migration do
  change do
    alter_table :products do
      drop_column :active
      add_column :active, TrueClass, null: false, default: true
    end
  end
end

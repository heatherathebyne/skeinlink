class AddCreatedByToYarnDatabaseObjects < ActiveRecord::Migration[6.0]
  def change
    add_column :colorways, :created_by, :bigint, null: true
    add_column :yarn_products, :created_by, :bigint, null: true
    add_column :yarn_companies, :created_by, :bigint, null: true

    add_foreign_key :yarn_companies, :users, column: 'created_by'
    add_foreign_key :yarn_products, :users, column: 'created_by'
    add_foreign_key :colorways, :users, column: 'created_by'
  end
end

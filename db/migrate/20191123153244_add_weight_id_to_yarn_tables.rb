class AddWeightIdToYarnTables < ActiveRecord::Migration[6.0]
  def change
    add_column :stash_yarns, :weight_id, :integer, limit: 1
    add_index :stash_yarns, :weight_id
    add_column :yarn_products, :weight_id, :integer, limit: 1
    add_index :yarn_products, :weight_id
  end
end

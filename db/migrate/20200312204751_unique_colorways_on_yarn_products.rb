class UniqueColorwaysOnYarnProducts < ActiveRecord::Migration[6.0]
  def change
    add_index :colorways, [:yarn_product_id, :name], unique: true
    add_index :colorways, [:yarn_product_id, :number], unique: true
  end
end

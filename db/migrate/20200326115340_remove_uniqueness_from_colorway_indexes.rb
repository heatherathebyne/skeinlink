class RemoveUniquenessFromColorwayIndexes < ActiveRecord::Migration[6.0]
  def change
    remove_index :colorways, [:yarn_product_id, :name]
    remove_index :colorways, [:yarn_product_id, :number]
    add_index :colorways, [:yarn_product_id, :name]
    add_index :colorways, [:yarn_product_id, :number]
  end
end

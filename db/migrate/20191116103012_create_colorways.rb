class CreateColorways < ActiveRecord::Migration[6.0]
  def change
    create_table :colorways do |t|
      t.references :yarn_product, null: false
      t.string :name, null: false
      t.index :name
      t.string :number # don't assume this is always an int
      t.index :number
      t.timestamps
    end
  end
end

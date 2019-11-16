class CreateYarnProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :yarn_products do |t|
      t.references :yarn_company
      t.references :colorway
      t.string :name, null: false
      t.index :name
      t.integer :skein_gram_weight
      t.integer :skein_yards
      t.string :fiber_type_name
      t.integer :craft_yarn_council_weight, limit: 1
      t.index :craft_yarn_council_weight
      t.string :weight_name
      t.timestamps
    end
  end
end

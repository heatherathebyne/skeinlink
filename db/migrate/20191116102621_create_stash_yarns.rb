class CreateStashYarns < ActiveRecord::Migration[6.0]
  def change
    create_table :stash_yarns do |t|
      t.references :yarn_product
      t.references :colorway
      t.references :user, null: false
      t.string :name # nullable because we mostly want to reference YarnProduct
      t.string :colorway_name
      t.date :purchase_date
      t.index :purchase_date
      t.string :purchased_at_name
      t.index :purchased_at_name
      t.string :purchase_price
      t.integer :skein_quantity
      t.integer :total_yardage
      t.timestamps
    end
  end
end

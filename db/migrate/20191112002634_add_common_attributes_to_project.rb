class AddCommonAttributesToProject < ActiveRecord::Migration[6.0]
  def change
    change_table :projects do |t|
      t.integer :status, limit: 1
      t.index :status
      t.integer :progress, limit: 1, default: 0
      t.text :private_notes
      t.string :tools_freetext
    end
  end
  # HABTMs planned, will come later
end

class AddOtherMakerTypeToStashYarn < ActiveRecord::Migration[6.0]
  def change
    add_column :stash_yarns, :other_maker_type, :integer, limit: 1
    add_index :stash_yarns, :other_maker_type
  end
end

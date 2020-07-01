class AddDyeLotToStashYarns < ActiveRecord::Migration[6.0]
  def change
    add_column :stash_yarns, :dye_lot, :string
  end
end

class AddNotesToStashYarn < ActiveRecord::Migration[6.0]
  def change
    add_column :stash_yarns, :notes, :text # haha, this might be useful too
    add_column :stash_yarns, :handspun, :boolean
    add_index :stash_yarns, :handspun
  end
end

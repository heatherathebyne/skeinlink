class AddPublicFlagToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :publicly_visible, :boolean, null: false, default: false
    add_index :projects, :publicly_visible
  end
end

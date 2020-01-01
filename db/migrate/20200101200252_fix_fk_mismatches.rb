class FixFkMismatches < ActiveRecord::Migration[6.0]
  def up
    change_column :journal_entries, :project_id, :bigint
    change_column :projects, :craft_id, :bigint
  end

  def down
    change_column :journal_entries, :project_id, :integer
    change_column :projects, :craft_id, :integer
  end
end

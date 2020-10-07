class AddStashUsagesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :stash_usages do |t|
      t.bigint :project_id, null: false
      t.bigint :stash_yarn_id, null: false
      t.integer :yards_used, default: 0
      t.timestamps

      t.index :project_id
      t.index :stash_yarn_id
    end
  end
end

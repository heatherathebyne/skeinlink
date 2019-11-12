class AddJournalEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :journal_entries do |t|
      t.integer :project_id
      t.datetime :entry_timestamp, null: false
      t.index :entry_timestamp
      t.text :content
      t.timestamps
    end

    add_foreign_key :journal_entries, :projects
  end
end

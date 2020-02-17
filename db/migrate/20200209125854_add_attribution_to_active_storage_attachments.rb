class AddAttributionToActiveStorageAttachments < ActiveRecord::Migration[6.0]
  def change
    add_column :active_storage_attachments, :attribution, :string, null: false, default: ''
  end
end

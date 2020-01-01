class FixActiveStorageAttachmentsBigint < ActiveRecord::Migration[6.0]
  def change
    change_column :active_storage_attachments, :blob_id, :bigint, null: false
  end
end

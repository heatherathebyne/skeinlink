class AddIdpUidToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :idp_uid, :bigint, unique: true
    add_index :users, :idp_uid
  end
end

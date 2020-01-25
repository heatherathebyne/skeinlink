class AddRolesToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :role_superadmin, :boolean, null: false, default: false
    add_column :users, :role_admin, :boolean, null: false, default: false
    add_column :users, :role_maintainer, :boolean, null: false, default: false
    add_column :users, :role_moderator, :boolean, null: false, default: false
    add_index :users, :role_superadmin
    add_index :users, :role_admin
    add_index :users, :role_maintainer
    add_index :users, :role_moderator
  end
end

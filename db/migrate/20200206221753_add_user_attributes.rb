class AddUserAttributes < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string, null: false, default: 'Anonymous Crafter'
    add_index :users, :name
    add_column :users, :about_me, :text, null: false, default: ''
    add_column :users, :active, :boolean, null: false, default: true
    add_index :users, :active
  end
end

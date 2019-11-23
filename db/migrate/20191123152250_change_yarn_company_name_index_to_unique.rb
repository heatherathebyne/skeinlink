class ChangeYarnCompanyNameIndexToUnique < ActiveRecord::Migration[6.0]
  def change
    remove_index :yarn_companies, :name
    add_index :yarn_companies, :name, unique: true
  end
end

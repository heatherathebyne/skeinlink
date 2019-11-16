class CreateYarnCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :yarn_companies do |t|
      t.string :name, null: false
      t.index :name
      t.timestamps
    end
  end
end

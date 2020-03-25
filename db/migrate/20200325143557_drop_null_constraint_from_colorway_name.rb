class DropNullConstraintFromColorwayName < ActiveRecord::Migration[6.0]
  def change
    change_column :colorways, :name, :string, null: true
  end
end

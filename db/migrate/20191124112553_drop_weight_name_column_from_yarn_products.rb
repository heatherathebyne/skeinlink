class DropWeightNameColumnFromYarnProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :yarn_products, :weight_name
  end
end

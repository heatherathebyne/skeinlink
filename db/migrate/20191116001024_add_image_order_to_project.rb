class AddImageOrderToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :image_order, :text
  end
end

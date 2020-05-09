class UnborkDefaultValues < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :about_me, :text, default: nil
    change_column :yarn_products, :description, :text, default: nil
  end
end

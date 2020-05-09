class NullableTextFields < ActiveRecord::Migration[6.0]
  def change
    change_column :yarn_products, :description, :text, null: true
    change_column :users, :about_me, :text, null: true
  end
end

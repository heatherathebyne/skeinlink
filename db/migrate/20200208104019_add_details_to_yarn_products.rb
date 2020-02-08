class AddDetailsToYarnProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :yarn_products, :description, :text, null: false, default: ''
    add_column :yarn_products, :referral_link, :string
    add_column :yarn_products, :referral_partner, :string
  end
end

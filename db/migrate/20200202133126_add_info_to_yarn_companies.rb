class AddInfoToYarnCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :yarn_companies, :website, :string
    add_column :yarn_companies, :description, :text
    add_column :yarn_companies, :referral_link, :string
    add_column :yarn_companies, :referral_partner, :string
  end
end

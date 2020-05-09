class FixBigint < ActiveRecord::Migration[6.0]
  def change
    change_column :taggings, :tag_id, :bigint
  end
end

class AddAllThePatternTables < ActiveRecord::Migration[6.0]
  def change
    create_table :patterns do |t|
      t.references :pattern_pattern_publishers, :pattern_pattern_designers, :pattern_yarn_products, :pattern_projects
      t.string :name, null: false, index: { unique: true }
      t.timestamps
    end

    create_table :pattern_designers do |t|
      t.references :pattern_pattern_designers
      t.string :name, null: false, index: { unique: true }
      t.timestamps
    end

    create_table :pattern_publishers do |t|
      t.references :pattern_pattern_publishers
      t.string :name, null: false, index: { unique: true }
      t.timestamps
    end

    create_table :pattern_pattern_publishers do |t|
      t.references :patterns, :pattern_publishers, foreign_key: true
      t.timestamps
    end

    create_table :pattern_pattern_designers do |t|
      t.references :patterns, :pattern_designers, foreign_key: true
      t.timestamps
    end

    create_table :pattern_yarn_products do |t|
      t.references :patterns, :yarn_products, foreign_key: true
      t.timestamps
    end

    create_table :pattern_projects do |t|
      t.references :patterns, :projects, foreign_key: true
      t.timestamps
    end
  end
end

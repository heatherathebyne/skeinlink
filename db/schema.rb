# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_09_131843) do

  create_table "crafts", force: :cascade do |t|
    t.string "name"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "craft_id", null: false
    t.integer "user_id"
    t.string "name", null: false
    t.string "pattern_name"
    t.string "status_name"
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["craft_id"], name: "index_projects_on_craft_id"
    t.index ["name"], name: "index_projects_on_name"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "yarns", force: :cascade do |t|
    t.string "name", null: false
    t.string "company_name", null: false
    t.string "weight_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_name"], name: "index_yarns_on_company_name"
    t.index ["name"], name: "index_yarns_on_name", unique: true
    t.index ["weight_name"], name: "index_yarns_on_weight_name"
  end

  add_foreign_key "projects", "crafts"
end

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

ActiveRecord::Schema.define(version: 2020_01_01_131540) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "colorways", force: :cascade do |t|
    t.integer "yarn_product_id", null: false
    t.string "name", null: false
    t.string "number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_colorways_on_name"
    t.index ["number"], name: "index_colorways_on_number"
    t.index ["yarn_product_id"], name: "index_colorways_on_yarn_product_id"
  end

  create_table "crafts", force: :cascade do |t|
    t.string "name"
  end

  create_table "journal_entries", force: :cascade do |t|
    t.integer "project_id"
    t.datetime "entry_timestamp", null: false
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["entry_timestamp"], name: "index_journal_entries_on_entry_timestamp"
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
    t.integer "status", limit: 1
    t.integer "progress", limit: 1, default: 0
    t.text "private_notes"
    t.string "tools_freetext"
    t.text "image_order"
    t.boolean "publicly_visible", default: false, null: false
    t.index ["craft_id"], name: "index_projects_on_craft_id"
    t.index ["name"], name: "index_projects_on_name"
    t.index ["publicly_visible"], name: "index_projects_on_publicly_visible"
    t.index ["status"], name: "index_projects_on_status"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "stash_yarns", force: :cascade do |t|
    t.integer "yarn_product_id"
    t.integer "colorway_id"
    t.integer "user_id", null: false
    t.string "name"
    t.string "colorway_name"
    t.date "purchase_date"
    t.string "purchased_at_name"
    t.string "purchase_price"
    t.integer "skein_quantity"
    t.integer "total_yardage"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "notes"
    t.boolean "handspun"
    t.integer "weight_id", limit: 1
    t.index ["colorway_id"], name: "index_stash_yarns_on_colorway_id"
    t.index ["handspun"], name: "index_stash_yarns_on_handspun"
    t.index ["purchase_date"], name: "index_stash_yarns_on_purchase_date"
    t.index ["purchased_at_name"], name: "index_stash_yarns_on_purchased_at_name"
    t.index ["user_id"], name: "index_stash_yarns_on_user_id"
    t.index ["weight_id"], name: "index_stash_yarns_on_weight_id"
    t.index ["yarn_product_id"], name: "index_stash_yarns_on_yarn_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "yarn_companies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_yarn_companies_on_name", unique: true
  end

  create_table "yarn_products", force: :cascade do |t|
    t.integer "yarn_company_id"
    t.integer "colorway_id"
    t.string "name", null: false
    t.integer "skein_gram_weight"
    t.integer "skein_yards"
    t.string "fiber_type_name"
    t.integer "craft_yarn_council_weight", limit: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "weight_id", limit: 1
    t.index ["colorway_id"], name: "index_yarn_products_on_colorway_id"
    t.index ["craft_yarn_council_weight"], name: "index_yarn_products_on_craft_yarn_council_weight"
    t.index ["name"], name: "index_yarn_products_on_name"
    t.index ["weight_id"], name: "index_yarn_products_on_weight_id"
    t.index ["yarn_company_id"], name: "index_yarn_products_on_yarn_company_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "journal_entries", "projects"
  add_foreign_key "projects", "crafts"
end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_08_20_135737) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "attribution", default: "", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "latin1", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audits", charset: "latin1", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at", precision: nil
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "colorways", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "yarn_product_id", null: false
    t.string "name"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by"
    t.index ["created_by"], name: "fk_rails_f8e8660301"
    t.index ["name"], name: "index_colorways_on_name"
    t.index ["number"], name: "index_colorways_on_number"
    t.index ["yarn_product_id", "name"], name: "index_colorways_on_yarn_product_id_and_name"
    t.index ["yarn_product_id", "number"], name: "index_colorways_on_yarn_product_id_and_number"
    t.index ["yarn_product_id"], name: "index_colorways_on_yarn_product_id"
  end

  create_table "crafts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
  end

  create_table "journal_entries", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "project_id"
    t.datetime "entry_timestamp", precision: nil, null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_timestamp"], name: "index_journal_entries_on_entry_timestamp"
    t.index ["project_id"], name: "fk_rails_2d674f2d76"
  end

  create_table "projects", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "craft_id", null: false
    t.integer "user_id"
    t.string "name", null: false
    t.string "pattern_name"
    t.string "status_name"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "stash_usages", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "stash_yarn_id", null: false
    t.integer "yards_used", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_stash_usages_on_project_id"
    t.index ["stash_yarn_id"], name: "index_stash_usages_on_stash_yarn_id"
  end

  create_table "stash_yarns", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.boolean "handspun"
    t.integer "weight_id", limit: 1
    t.integer "other_maker_type", limit: 1
    t.string "dye_lot"
    t.index ["colorway_id"], name: "index_stash_yarns_on_colorway_id"
    t.index ["handspun"], name: "index_stash_yarns_on_handspun"
    t.index ["other_maker_type"], name: "index_stash_yarns_on_other_maker_type"
    t.index ["purchase_date"], name: "index_stash_yarns_on_purchase_date"
    t.index ["purchased_at_name"], name: "index_stash_yarns_on_purchased_at_name"
    t.index ["user_id"], name: "index_stash_yarns_on_user_id"
    t.index ["weight_id"], name: "index_stash_yarns_on_weight_id"
    t.index ["yarn_product_id"], name: "index_stash_yarns_on_yarn_product_id"
  end

  create_table "taggings", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", collation: "utf8_bin"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "role_superadmin", default: false, null: false
    t.boolean "role_admin", default: false, null: false
    t.boolean "role_maintainer", default: false, null: false
    t.boolean "role_moderator", default: false, null: false
    t.string "name", default: "Anonymous Crafter", null: false
    t.text "about_me"
    t.boolean "active", default: true, null: false
    t.index ["active"], name: "index_users_on_active"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_admin"], name: "index_users_on_role_admin"
    t.index ["role_maintainer"], name: "index_users_on_role_maintainer"
    t.index ["role_moderator"], name: "index_users_on_role_moderator"
    t.index ["role_superadmin"], name: "index_users_on_role_superadmin"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "yarn_companies", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "website"
    t.text "description"
    t.string "referral_link"
    t.string "referral_partner"
    t.bigint "created_by"
    t.index ["created_by"], name: "fk_rails_c80fbf6c34"
    t.index ["name"], name: "index_yarn_companies_on_name", unique: true
  end

  create_table "yarn_products", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "yarn_company_id"
    t.integer "colorway_id"
    t.string "name", null: false
    t.integer "skein_gram_weight"
    t.integer "skein_yards"
    t.string "fiber_type_name"
    t.integer "craft_yarn_council_weight", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight_id", limit: 1
    t.text "description"
    t.string "referral_link"
    t.string "referral_partner"
    t.bigint "created_by"
    t.index ["colorway_id"], name: "index_yarn_products_on_colorway_id"
    t.index ["craft_yarn_council_weight"], name: "index_yarn_products_on_craft_yarn_council_weight"
    t.index ["created_by"], name: "fk_rails_c5bb2391ee"
    t.index ["name"], name: "index_yarn_products_on_name"
    t.index ["weight_id"], name: "index_yarn_products_on_weight_id"
    t.index ["yarn_company_id"], name: "index_yarn_products_on_yarn_company_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "colorways", "users", column: "created_by"
  add_foreign_key "journal_entries", "projects"
  add_foreign_key "projects", "crafts"
  add_foreign_key "taggings", "tags"
  add_foreign_key "yarn_companies", "users", column: "created_by"
  add_foreign_key "yarn_products", "users", column: "created_by"
end

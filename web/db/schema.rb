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

ActiveRecord::Schema[8.1].define(version: 2026_05_27_013648) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.text "analysis"
    t.datetime "created_at", null: false
    t.text "flags"
    t.datetime "last_checked"
    t.string "name"
    t.text "privacy_analysis"
    t.text "privacy_summary"
    t.text "privacy_text"
    t.string "privacy_url"
    t.float "risk_score"
    t.text "summary"
    t.text "tos_analysis"
    t.text "tos_summary"
    t.text "tos_text"
    t.string "tos_url"
    t.datetime "updated_at", null: false
    t.string "url"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "registration_id", null: false
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_messages_on_registration_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["company_id"], name: "index_registrations_on_company_id"
    t.index ["user_id"], name: "index_registrations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "nickname"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "messages", "registrations"
  add_foreign_key "registrations", "companies"
  add_foreign_key "registrations", "users"
end

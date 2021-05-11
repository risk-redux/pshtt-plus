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

ActiveRecord::Schema.define(version: 2021_05_11_134341) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "domains", force: :cascade do |t|
    t.text "domain_name"
    t.text "a_record"
    t.text "aaaa_record"
    t.text "cname_record"
    t.text "notes"
    t.datetime "checked_at", precision: 6
    t.datetime "last_live_at", precision: 6
    t.boolean "is_live"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reports", force: :cascade do |t|
    t.text "content_blob"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "approved", default: false, null: false
    t.index ["approved"], name: "index_users_on_approved"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "websites", force: :cascade do |t|
    t.bigint "domain_id"
    t.boolean "is_https", null: false
    t.boolean "is_www", null: false
    t.text "digest"
    t.text "notes"
    t.integer "http_status_code"
    t.text "http_status"
    t.boolean "is_hsts"
    t.integer "hsts_max_age"
    t.text "redirect_url"
    t.text "report_card"
    t.boolean "is_behaving"
    t.text "certificate"
    t.datetime "not_before"
    t.datetime "not_after"
    t.text "issuer"
    t.text "subject"
    t.datetime "checked_at", precision: 6
    t.datetime "last_live_at", precision: 6
    t.boolean "is_live"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["domain_id"], name: "index_websites_on_domain_id"
  end

end

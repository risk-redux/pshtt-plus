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

ActiveRecord::Schema.define(version: 2021_04_22_155320) do

  create_table "domains", force: :cascade do |t|
    t.text "domain_name"
    t.text "url"
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

  create_table "websites", force: :cascade do |t|
    t.belongs_to :domain, foriegn_key: true
    
    t.boolean "is_https"
    t.boolean "is_www"
    t.text "digest"
    t.text "notes"
    t.integer "http_status_code"
    t.text "http_status"
    t.boolean "is_hsts"
    t.integer "hsts_max_age"
    t.text "redirect_url"

    t.datetime "checked_at", precision: 6
    t.datetime "last_live_at", precision: 6
    t.boolean "is_live"

    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end

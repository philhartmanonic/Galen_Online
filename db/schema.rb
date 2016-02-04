# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160202024248) do

  create_table "bands", force: :cascade do |t|
    t.string   "name"
    t.string   "fb_id"
    t.string   "thumb_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.string   "p_or_c"
    t.date     "gop_date"
    t.date     "dem_date"
    t.integer  "gop_pledged"
    t.integer  "gop_unpledged"
    t.integer  "dem_pledged"
    t.integer  "dem_unpledged"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "map_file_name"
    t.string   "map_content_type"
    t.integer  "map_file_size"
    t.datetime "map_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "users_bands", force: :cascade do |t|
    t.integer "user_id"
    t.integer "band_id"
  end

  add_index "users_bands", ["band_id"], name: "index_users_bands_on_band_id"
  add_index "users_bands", ["user_id"], name: "index_users_bands_on_user_id"

end

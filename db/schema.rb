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

ActiveRecord::Schema.define(version: 20160513231415) do

  create_table "artists", force: :cascade do |t|
    t.string   "name"
    t.string   "spotify_uri"
    t.string   "spotify_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "artists_genres", force: :cascade do |t|
    t.integer  "artist_id"
    t.integer  "genre_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "artists_genres", ["artist_id"], name: "index_artists_genres_on_artist_id"
  add_index "artists_genres", ["genre_id"], name: "index_artists_genres_on_genre_id"

  create_table "candidates", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "pollster_slug"
    t.integer  "party_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "profile_file_name"
    t.string   "profile_content_type"
    t.integer  "profile_file_size"
    t.datetime "profile_updated_at"
  end

  add_index "candidates", ["party_id"], name: "index_candidates_on_party_id"

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "upvotes"
    t.integer  "downvotes"
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "elections", force: :cascade do |t|
    t.integer  "state_id"
    t.integer  "candidate_id"
    t.integer  "party_id"
    t.integer  "percent"
    t.integer  "regs"
    t.integer  "supers"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "elections", ["candidate_id"], name: "index_elections_on_candidate_id"
  add_index "elections", ["state_id"], name: "index_elections_on_state_id"

  create_table "genres", force: :cascade do |t|
    t.string "name"
  end

  create_table "parties", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "win_number"
  end

  create_table "playlists", force: :cascade do |t|
    t.string   "name"
    t.string   "href"
    t.string   "spotify_id"
    t.string   "spotify_uri"
    t.string   "track_link"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "playlists_tracks", force: :cascade do |t|
    t.integer  "track_id"
    t.integer  "playlist_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "playlists_tracks", ["playlist_id"], name: "index_playlists_tracks_on_playlist_id"
  add_index "playlists_tracks", ["track_id"], name: "index_playlists_tracks_on_track_id"

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id"
    t.string   "main_image_file_name"
    t.string   "main_image_content_type"
    t.integer  "main_image_file_size"
    t.datetime "main_image_updated_at"
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.string   "p_or_c"
    t.date     "gop_date"
    t.date     "dem_date"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "map_file_name"
    t.string   "map_content_type"
    t.integer  "map_file_size"
    t.datetime "map_updated_at"
    t.string   "dem_poll_slug"
    t.string   "gop_poll_slug"
  end

  create_table "tracks", force: :cascade do |t|
    t.string   "name"
    t.integer  "duration"
    t.boolean  "explicit"
    t.float    "danceability"
    t.float    "energy"
    t.integer  "key"
    t.float    "loudness"
    t.integer  "mode"
    t.float    "speechiness"
    t.float    "acousticness"
    t.float    "instrumentalness"
    t.float    "liveness"
    t.float    "valence"
    t.float    "tempo"
    t.string   "spotify_id"
    t.string   "spotify_uri"
    t.string   "href"
    t.integer  "time_signature"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "tracks_artists", force: :cascade do |t|
    t.integer  "track_id"
    t.integer  "artist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tracks_artists", ["artist_id"], name: "index_tracks_artists_on_artist_id"
  add_index "tracks_artists", ["track_id"], name: "index_tracks_artists_on_track_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "role_id"
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["role_id"], name: "index_users_on_role_id"

  create_table "votes", force: :cascade do |t|
    t.boolean  "up",               default: true, null: false
    t.integer  "takes_votes_id"
    t.string   "takes_votes_type"
    t.integer  "user_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "votes", ["user_id"], name: "index_votes_on_user_id"

end

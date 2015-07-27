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

ActiveRecord::Schema.define(version: 20150511224513) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["name"], name: "index_cities_on_name", using: :btree

  create_table "comments", force: true do |t|
    t.string   "username"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree

  create_table "concerts", force: true do |t|
    t.string   "name"
    t.string   "street_address"
    t.string   "zip"
    t.float    "latitude"
    t.float    "longitude"
    t.decimal  "people_score"
    t.decimal  "music_score"
    t.decimal  "venue_score"
    t.decimal  "atmosphere_score"
    t.decimal  "aggregate_score"
    t.integer  "votes"
    t.integer  "rank"
    t.integer  "user_id"
    t.integer  "genre_id"
    t.integer  "venue_id"
    t.integer  "city_id"
    t.integer  "state_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "concerts", ["rank"], name: "index_concerts_on_rank", using: :btree

  create_table "countries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["name"], name: "index_countries_on_name", using: :btree

  create_table "genres", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.string   "referrer_username"
    t.integer  "profile_id"
    t.integer  "comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: true do |t|
    t.string   "real_name"
    t.integer  "age"
    t.string   "hometown"
    t.string   "favorite_artists"
    t.string   "favorite_songs"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", force: true do |t|
    t.integer  "people_score"
    t.integer  "music_score"
    t.integer  "venue_score"
    t.integer  "atmosphere_score"
    t.integer  "concert_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "states", ["name"], name: "index_states_on_name", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.boolean  "admin",                  default: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "venues", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "venues", ["name"], name: "index_venues_on_name", using: :btree

  create_table "videos", force: true do |t|
    t.string   "url"
    t.integer  "concert_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

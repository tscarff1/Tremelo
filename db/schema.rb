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

ActiveRecord::Schema.define(version: 20150314225859) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "band_genres", force: true do |t|
    t.integer  "band_id"
    t.integer  "genre_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "band_musics", force: true do |t|
    t.integer  "band_id"
    t.text     "embed_html"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "band_videos", force: true do |t|
    t.integer  "band_id"
    t.string   "video_link"
    t.string   "video_link_html"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "video_name"
  end

  create_table "bands", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "about_me"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_picture_file_name"
    t.string   "profile_picture_content_type"
    t.integer  "profile_picture_file_size"
    t.datetime "profile_picture_updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "full_address"
  end

  create_table "genres", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content"
  end

  create_table "tags", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content"
  end

  create_table "user_bands", force: true do |t|
    t.integer  "user_id"
    t.integer  "band_id"
    t.integer  "admin_priveleges"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

  create_table "user_tags", force: true do |t|
    t.integer  "user_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "display_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "about_me"
    t.string   "home_address"
    t.string   "state"
    t.string   "password_reset_token"
    t.string   "profile_picture_file_name"
    t.string   "profile_picture_content_type"
    t.integer  "profile_picture_file_size"
    t.datetime "profile_picture_updated_at"
    t.date     "date_of_birth"
    t.integer  "zipcode"
    t.string   "city"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["password_reset_token"], name: "index_users_on_password_reset_token", using: :btree

  create_table "videos", force: true do |t|
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.integer  "band_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

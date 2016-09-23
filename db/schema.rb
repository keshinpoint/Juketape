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

ActiveRecord::Schema.define(version: 20160923074525) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "facebook_networks", force: :cascade do |t|
    t.string   "token",           default: ""
    t.string   "secret",          default: ""
    t.string   "page_token",      default: ""
    t.integer  "user_id",                      null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "selected_videos", default: [],              array: true
    t.json     "all_videos",      default: [],              array: true
    t.string   "display_name"
  end

  create_table "instagram_networks", force: :cascade do |t|
    t.string   "access_token",    default: ""
    t.integer  "user_id",                      null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "selected_images", default: [],              array: true
    t.json     "all_images",      default: [],              array: true
    t.string   "display_name"
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "initiator_id",             null: false
    t.integer  "invitee_id",               null: false
    t.boolean  "accepted"
    t.string   "known_by"
    t.date     "sent_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "status",       default: 0
  end

  create_table "soundcloud_networks", force: :cascade do |t|
    t.string   "access_token",                 null: false
    t.string   "refresh_token",   default: ""
    t.integer  "user_id",                      null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "selected_tracks", default: [],              array: true
    t.string   "selected_albums", default: [],              array: true
    t.json     "all_tracks",      default: [],              array: true
    t.json     "all_albums",      default: [],              array: true
    t.string   "display_name"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timeline_events", force: :cascade do |t|
    t.string   "title",       null: false
    t.string   "description", null: false
    t.string   "location"
    t.date     "start_date",  null: false
    t.date     "end_date"
    t.boolean  "at_present"
    t.integer  "user_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                          null: false
    t.string   "username",                                       null: false
    t.string   "encrypted_password", limit: 128,                 null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128,                 null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.boolean  "finalized_setup",                default: false
    t.string   "image"
    t.string   "act_name"
    t.string   "tag_line"
    t.string   "location"
    t.text     "bio"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["remember_token"], name: "index_users_on_remember_token", using: :btree
  end

  create_table "youtube_networks", force: :cascade do |t|
    t.string   "access_token",    default: ""
    t.string   "refresh_token",   default: ""
    t.string   "expires_in",      default: ""
    t.integer  "user_id",                      null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "selected_videos", default: [],              array: true
    t.json     "all_videos",      default: [],              array: true
    t.string   "display_name"
  end

end

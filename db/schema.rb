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

ActiveRecord::Schema.define(version: 20160908140053) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "full_name"
    t.text     "description"
    t.string   "website"
    t.string   "address"
    t.string   "username",               default: "", null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "coverpic_file_name"
    t.string   "coverpic_content_type"
    t.integer  "coverpic_file_size"
    t.datetime "coverpic_updated_at"
    t.index ["email"], name: "index_artists_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_artists_on_reset_password_token", unique: true, using: :btree
  end

  create_table "facebook_networks", force: :cascade do |t|
    t.string   "token",          default: ""
    t.string   "secret",         default: ""
    t.string   "page_token",     default: ""
    t.integer  "artist_id",                   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "selected_items", default: [],              array: true
    t.string   "page_id",        default: ""
  end

  create_table "soundcloud_networks", force: :cascade do |t|
    t.string   "access_token",   default: ""
    t.string   "refresh_token",  default: ""
    t.integer  "artist_id",                   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "selected_items", default: [],              array: true
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
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["remember_token"], name: "index_users_on_remember_token", using: :btree
  end

  create_table "youtube_networks", force: :cascade do |t|
    t.string   "access_token",   default: ""
    t.string   "refresh_token",  default: ""
    t.string   "expires_in",     default: ""
    t.integer  "artist_id",                   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "selected_items", default: [],              array: true
  end

end

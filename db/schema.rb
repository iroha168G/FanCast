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

ActiveRecord::Schema[7.2].define(version: 2026_02_18_013951) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "channels", force: :cascade do |t|
    t.integer "platform", null: false
    t.string "name", null: false
    t.string "channel_identifier", null: false
    t.string "thumbnail_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["platform", "channel_identifier"], name: "index_channels_on_platform_and_channel_identifier", unique: true
  end

  create_table "user_favorite_channels", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "channel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_user_favorite_channels_on_channel_id"
    t.index ["user_id", "channel_id"], name: "index_user_favorite_channels_on_user_id_and_channel_id", unique: true
    t.index ["user_id"], name: "index_user_favorite_channels_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean "activated"
    t.boolean "mock_user", default: false, null: false
  end

  add_foreign_key "user_favorite_channels", "channels"
  add_foreign_key "user_favorite_channels", "users"
end

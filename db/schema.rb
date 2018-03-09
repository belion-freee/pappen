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

ActiveRecord::Schema.define(version: 20180125092908) do

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.string "place"
    t.datetime "start"
    t.datetime "end"
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.string "name"
    t.integer "event_id"
    t.integer "room_member_id"
    t.integer "payment"
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "last_dialogue_infos", force: :cascade do |t|
    t.string "uid", null: false
    t.string "mode", null: false
    t.string "context", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_last_dialogue_infos_on_uid", unique: true
  end

  create_table "last_location_infos", force: :cascade do |t|
    t.string "uid", null: false
    t.float "lat", null: false
    t.float "lon", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_last_location_infos_on_uid", unique: true
  end

  create_table "maxims", force: :cascade do |t|
    t.string "category"
    t.string "remark"
    t.string "author"
    t.string "source"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "room_member_events", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "room_member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_room_member_events_on_event_id"
    t.index ["room_member_id"], name: "index_room_member_events_on_room_member_id"
  end

  create_table "room_members", force: :cascade do |t|
    t.string "gid"
    t.string "uid", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

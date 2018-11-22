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

ActiveRecord::Schema.define(version: 20181120030000) do

  create_table "download_torrents", force: :cascade do |t|
    t.string "line_user_id", null: false
    t.string "hash_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.string "place"
    t.datetime "start"
    t.datetime "end"
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenditures", force: :cascade do |t|
    t.string "line_user_id", null: false
    t.date "entry_date", null: false
    t.string "category", null: false
    t.integer "payment", null: false
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

  create_table "house_expenditure_margins", force: :cascade do |t|
    t.integer "house_expenditure_id", null: false
    t.integer "debtor", null: false
    t.integer "margin"
    t.integer "fixed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_expenditure_id"], name: "index_house_expenditure_margins_on_house_expenditure_id"
  end

  create_table "house_expenditures", force: :cascade do |t|
    t.integer "house_id", null: false
    t.integer "room_member_id", null: false
    t.date "entry_date", null: false
    t.string "category", null: false
    t.integer "payment", null: false
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id"], name: "index_house_expenditures_on_house_id"
    t.index ["room_member_id"], name: "index_house_expenditures_on_room_member_id"
  end

  create_table "houses", force: :cascade do |t|
    t.string "name", null: false
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

  create_table "last_maxim_infos", force: :cascade do |t|
    t.integer "maxim_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_users", force: :cascade do |t|
    t.string "code", null: false
    t.string "uid", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean "paid", default: false
    t.index ["event_id"], name: "index_room_member_events_on_event_id"
    t.index ["room_member_id"], name: "index_room_member_events_on_room_member_id"
  end

  create_table "room_member_houses", force: :cascade do |t|
    t.integer "house_id", null: false
    t.integer "room_member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id"], name: "index_room_member_houses_on_house_id"
    t.index ["room_member_id"], name: "index_room_member_houses_on_room_member_id"
  end

  create_table "room_members", force: :cascade do |t|
    t.string "gid"
    t.string "uid", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "torrents", force: :cascade do |t|
    t.string "line_user_id", null: false
    t.integer "limit", null: false
    t.boolean "porn", default: false
    t.string "category"
    t.string "query"
    t.string "sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

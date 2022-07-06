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

ActiveRecord::Schema.define(version: 20220707020000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", primary_key: "eid", id: :string, force: :cascade do |t|
    t.bigserial "id", null: false
    t.string "name", null: false
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exempt_members", force: :cascade do |t|
    t.bigint "expense_id", null: false
    t.bigint "room_member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_exempt_members_on_expense_id"
    t.index ["room_member_id"], name: "index_exempt_members_on_room_member_id"
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
    t.string "event_id"
    t.integer "room_member_id"
    t.integer "payment"
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "house_bills", force: :cascade do |t|
    t.string "house_id", null: false
    t.date "entry_date", null: false
    t.boolean "done", default: false, null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id"], name: "index_house_bills_on_house_id"
  end

  create_table "house_expenditure_margins", force: :cascade do |t|
    t.bigint "house_expenditure_id", null: false
    t.bigint "room_member_id", null: false
    t.integer "margin"
    t.integer "fixed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_expenditure_id"], name: "index_house_expenditure_margins_on_house_expenditure_id"
    t.index ["room_member_id"], name: "index_house_expenditure_margins_on_room_member_id"
  end

  create_table "house_expenditures", force: :cascade do |t|
    t.string "house_id", null: false
    t.bigint "room_member_id", null: false
    t.date "entry_date", null: false
    t.string "category", null: false
    t.integer "payment", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id"], name: "index_house_expenditures_on_house_id"
    t.index ["room_member_id"], name: "index_house_expenditures_on_room_member_id"
  end

  create_table "houses", primary_key: "hid", id: :string, force: :cascade do |t|
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

  create_table "line_users", force: :cascade do |t|
    t.string "code", null: false
    t.string "uid", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "room_member_events", force: :cascade do |t|
    t.string "event_id", null: false
    t.bigint "room_member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "paid", default: false
    t.index ["event_id"], name: "index_room_member_events_on_event_id"
    t.index ["room_member_id"], name: "index_room_member_events_on_room_member_id"
  end

  create_table "room_member_houses", force: :cascade do |t|
    t.string "house_id", null: false
    t.bigint "room_member_id", null: false
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

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "exempt_members", "expenses"
  add_foreign_key "exempt_members", "room_members"
  add_foreign_key "expenses", "events", primary_key: "eid"
  add_foreign_key "house_bills", "houses", primary_key: "hid"
  add_foreign_key "house_expenditure_margins", "house_expenditures"
  add_foreign_key "house_expenditure_margins", "room_members"
  add_foreign_key "house_expenditures", "houses", primary_key: "hid"
  add_foreign_key "house_expenditures", "room_members"
  add_foreign_key "room_member_events", "events", primary_key: "eid"
  add_foreign_key "room_member_events", "room_members"
  add_foreign_key "room_member_houses", "houses", primary_key: "hid"
  add_foreign_key "room_member_houses", "room_members"
end

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

ActiveRecord::Schema.define(version: 20191124065152) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "month_order_superior_status"
    t.string "month_order_superior_id"
    t.boolean "agreement"
    t.string "month_order_status"
    t.string "month_order_id"
    t.integer "decision"
    t.string "overtime_order_id"
    t.string "overtime_order_status"
    t.boolean "over_next_day"
    t.datetime "endplans_time"
    t.string "business_outline"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "points", force: :cascade do |t|
    t.integer "point_number"
    t.string "point_name"
    t.string "point_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "department"
    t.datetime "basic_time", default: "2019-11-29 23:00:00"
    t.datetime "work_time", default: "2019-11-29 22:30:00"
    t.integer "employee_number"
    t.datetime "user_designated_work_start_time", default: "2019-11-30 00:00:00"
    t.datetime "user_designated_work_end_time", default: "2019-11-30 09:00:00"
    t.string "user_card_id"
    t.integer "decision"
    t.boolean "superior", default: false
  end

end

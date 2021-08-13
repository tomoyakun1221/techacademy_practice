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

ActiveRecord::Schema.define(version: 20210811121837) do

  create_table "attendances", force: :cascade do |t|
    t.integer "user_id"
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "change_approvals", force: :cascade do |t|
    t.integer "user_id"
    t.time "start_time"
    t.time "end_time"
    t.text "comment"
    t.integer "application_situation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "attendance_id"
    t.index ["attendance_id"], name: "index_change_approvals_on_attendance_id"
    t.index ["user_id"], name: "index_change_approvals_on_user_id"
  end

  create_table "overtime_approvals", force: :cascade do |t|
    t.integer "user_id"
    t.time "end_time"
    t.boolean "nextday_flag"
    t.integer "application_situation"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "attendance_id"
    t.integer "superior_id"
    t.index ["attendance_id"], name: "index_overtime_approvals_on_attendance_id"
    t.index ["superior_id"], name: "index_overtime_approvals_on_superior_id"
    t.index ["user_id"], name: "index_overtime_approvals_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.integer "role"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

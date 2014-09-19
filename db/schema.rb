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

ActiveRecord::Schema.define(version: 20140918152632) do

  create_table "appointments", force: true do |t|
    t.integer  "staff_id"
    t.integer  "customer_id"
    t.integer  "service_id"
    t.datetime "starttime"
    t.datetime "endtime"
    t.integer  "status",      default: 1
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "remark"
    t.datetime "deleted_at"
  end

  create_table "availabilities", force: true do |t|
    t.integer  "staff_id"
    t.integer  "service_id"
    t.time     "start_time"
    t.time     "end_time"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "deleted_at"
  end

  create_table "invitations", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "invitation_token"
    t.datetime "invitation_accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
    t.string   "invitee_type"
  end

  create_table "services", force: true do |t|
    t.string   "name"
    t.integer  "slot_window", default: 15
    t.boolean  "active",      default: true
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services_staffs", id: false, force: true do |t|
    t.integer "staff_id"
    t.integer "service_id"
  end

  create_table "site_layouts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "background_file_name"
    t.string   "background_content_type"
    t.integer  "background_file_size"
    t.datetime "background_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "type",                   default: "Customer"
    t.boolean  "active",                 default: true
    t.string   "email",                  default: "",         null: false
    t.string   "encrypted_password",     default: "",         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "deleted_at"
    t.string   "phone_number"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

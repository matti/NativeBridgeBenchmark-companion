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

ActiveRecord::Schema.define(version: 20140527151251) do

  create_table "results", force: true do |t|
    t.integer  "test_id"
    t.datetime "webview_started_at"
    t.datetime "webview_received_at"
    t.datetime "native_received_at"
    t.datetime "native_started_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "webview_payload_length"
    t.string   "from"
    t.integer  "fps"
    t.integer  "native_payload_length"
    t.string   "method"
    t.string   "method_name"
    t.float    "webview_to_native_delta"
    t.float    "native_to_webview_delta"
  end

  add_index "results", ["test_id"], name: "index_results_on_test_id"

  create_table "tests", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

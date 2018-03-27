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

ActiveRecord::Schema.define(version: 2018_03_27_190601) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "config_settings", force: :cascade do |t|
    t.string "title"
    t.string "setting"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices", force: :cascade do |t|
    t.string "device_uid"
    t.string "ip_address"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lights", force: :cascade do |t|
    t.integer "light_identifier"
    t.string "uniqueid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 100
  end

  create_table "registrations", force: :cascade do |t|
    t.string "number"
    t.string "owner"
    t.integer "reg_length"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "on_state"
    t.integer "brightness_state"
    t.integer "hue_state"
    t.integer "saturation_state"
    t.string "effect"
    t.decimal "x_state"
    t.decimal "y_state"
    t.integer "ct_state"
    t.string "alert"
    t.bigint "light_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["light_id"], name: "index_states_on_light_id"
  end

end

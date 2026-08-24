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

ActiveRecord::Schema[8.1].define(version: 2026_08_24_223002) do
  create_table "diaper_changes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "notes"
    t.datetime "occurred_at", null: false
    t.string "size", null: false
    t.datetime "updated_at", null: false
    t.index ["occurred_at"], name: "index_diaper_changes_on_occurred_at"
    t.index ["size"], name: "index_diaper_changes_on_size"
  end

  create_table "diaper_purchases", force: :cascade do |t|
    t.string "brand"
    t.datetime "created_at", null: false
    t.text "notes"
    t.date "purchased_at", null: false
    t.integer "quantity", null: false
    t.string "size", null: false
    t.datetime "updated_at", null: false
    t.index ["purchased_at"], name: "index_diaper_purchases_on_purchased_at"
    t.index ["size"], name: "index_diaper_purchases_on_size"
  end
end

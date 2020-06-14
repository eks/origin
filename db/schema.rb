# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_14_175020) do

  create_table "houses", force: :cascade do |t|
    t.string "ownership_status"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_houses_on_user_id"
  end

  create_table "risk_profiles", force: :cascade do |t|
    t.string "life"
    t.string "home"
    t.string "auto"
    t.string "disability"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_risk_profiles_on_user_id"
  end

  create_table "scores", force: :cascade do |t|
    t.integer "life"
    t.integer "home"
    t.integer "auto"
    t.integer "disability"
    t.integer "risk_profile_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["risk_profile_id"], name: "index_scores_on_risk_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "age", default: 0
    t.integer "dependents", default: 0
    t.decimal "income", precision: 10, scale: 2, default: "0.0"
    t.string "marital_status", default: "single"
    t.string "risk_questions", default: "---\n- 0\n- 0\n- 0\n"
  end

  create_table "vehicles", force: :cascade do |t|
    t.integer "year"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_vehicles_on_user_id"
  end

  add_foreign_key "houses", "users"
  add_foreign_key "risk_profiles", "users"
  add_foreign_key "scores", "risk_profiles"
  add_foreign_key "vehicles", "users"
end

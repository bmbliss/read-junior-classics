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

ActiveRecord::Schema[7.1].define(version: 2024_09_11_060012) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "children", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.integer "grade_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_children_on_user_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collections_literary_works", id: false, force: :cascade do |t|
    t.bigint "literary_work_id", null: false
    t.bigint "collection_id", null: false
  end

  create_table "literary_works", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.string "work_type"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "volume"
    t.integer "page"
  end

  create_table "program_items", force: :cascade do |t|
    t.bigint "program_id", null: false
    t.bigint "literary_work_id", null: false
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["literary_work_id"], name: "index_program_items_on_literary_work_id"
    t.index ["program_id"], name: "index_program_items_on_program_id"
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recommended_grade"
  end

  create_table "reading_entries", force: :cascade do |t|
    t.bigint "child_id", null: false
    t.bigint "literary_work_id", null: false
    t.string "status"
    t.date "date_read"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id"], name: "index_reading_entries_on_child_id"
    t.index ["literary_work_id"], name: "index_reading_entries_on_literary_work_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "confirmed_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "children", "users"
  add_foreign_key "program_items", "literary_works"
  add_foreign_key "program_items", "programs"
  add_foreign_key "reading_entries", "children"
  add_foreign_key "reading_entries", "literary_works"
end

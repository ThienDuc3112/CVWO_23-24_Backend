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

ActiveRecord::Schema[7.1].define(version: 2023_12_30_085918) do
  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "colour"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "username"
    t.text "content"
    t.integer "upvotes"
    t.integer "thred_id", null: false
    t.date "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thred_id"], name: "index_posts_on_thred_id"
  end

  create_table "threds", force: :cascade do |t|
    t.string "title"
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_threds_on_category_id"
  end

  add_foreign_key "posts", "threds"
  add_foreign_key "threds", "categories"
end

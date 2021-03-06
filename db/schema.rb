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

ActiveRecord::Schema.define(version: 2018_10_07_134623) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "documents", force: :cascade do |t|
    t.string "document_name"
    t.integer "project_id"
    t.integer "user_id"
    t.boolean "is_valid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "doc_file"
  end

  create_table "invoice_items", force: :cascade do |t|
    t.string "description"
    t.integer "quantity"
    t.integer "unit_price"
    t.integer "invoice_id"
    t.boolean "is_valid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.string "invoice_number"
    t.date "issue_date"
    t.date "due_date"
    t.string "subject"
    t.integer "recipient"
    t.integer "status"
    t.float "tax"
    t.integer "total_payment"
    t.boolean "is_valid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "milestones", force: :cascade do |t|
    t.string "label"
    t.string "goal"
    t.integer "project_id"
    t.integer "user_id"
    t.boolean "is_valid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "project_name"
    t.text "description"
    t.integer "user_id"
    t.boolean "is_valid"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quotations", force: :cascade do |t|
    t.string "content"
    t.integer "user_id"
    t.integer "project_id"
    t.boolean "is_valid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

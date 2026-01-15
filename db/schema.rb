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

ActiveRecord::Schema[8.1].define(version: 2026_01_14_234533) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "answers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "question_id", null: false
    t.integer "score_value"
    t.bigint "submission_id", null: false
    t.text "text_value"
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["submission_id"], name: "index_answers_on_submission_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.string "kind"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_departments_on_ancestry"
  end

  create_table "employees", force: :cascade do |t|
    t.string "corporate_email", null: false
    t.datetime "created_at", null: false
    t.bigint "department_id", null: false
    t.string "email"
    t.string "gender"
    t.string "generation"
    t.bigint "job_id", null: false
    t.string "location"
    t.string "name", null: false
    t.string "tenure"
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_employees_on_department_id"
    t.index ["job_id"], name: "index_employees_on_job_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "function_name", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "category"
    t.datetime "created_at", null: false
    t.string "question_type", null: false
    t.string "text", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "employee_id", null: false
    t.datetime "responded_at", null: false
    t.string "snapshot_department_name"
    t.string "snapshot_job_title"
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_submissions_on_employee_id"
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "submissions"
  add_foreign_key "employees", "departments"
  add_foreign_key "employees", "jobs"
  add_foreign_key "submissions", "employees"
end

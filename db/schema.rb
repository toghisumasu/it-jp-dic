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

ActiveRecord::Schema[8.1].define(version: 2026_07_12_032114) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "words", force: :cascade do |t|
    t.string "base_form"
    t.datetime "created_at", null: false
    t.text "definition", null: false
    t.string "headword", null: false
    t.string "pos"
    t.datetime "updated_at", null: false
    t.index ["base_form"], name: "index_words_on_base_form"
    t.index ["definition"], name: "index_words_on_definition_trgm", opclass: :gin_trgm_ops, using: :gin
    t.index ["headword"], name: "index_words_on_headword"
    t.index ["headword"], name: "index_words_on_headword_trgm", opclass: :gin_trgm_ops, using: :gin
  end
end

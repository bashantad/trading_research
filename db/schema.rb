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

ActiveRecord::Schema.define(version: 2021_01_17_055710) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "traffics", force: :cascade do |t|
    t.date "record_date"
    t.float "page_views_per_million"
    t.float "page_views_per_user"
    t.integer "rank"
    t.float "reach_per_million"
    t.string "company_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_url", "record_date"], name: "index_traffics_on_company_url_and_record_date", unique: true
    t.index ["company_url"], name: "index_traffics_on_company_url"
  end

end

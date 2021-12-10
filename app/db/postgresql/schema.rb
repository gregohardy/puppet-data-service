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

ActiveRecord::Schema.define(version: 2021_12_08_173927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "changelog", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username"
    t.string "object_type"
    t.string "object_id"
    t.jsonb "change_details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_changelog_on_username"
  end

  create_table "hieradata", primary_key: ["level", "key"], force: :cascade do |t|
    t.string "level", null: false
    t.string "key", null: false
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_hieradata_on_key"
    t.index ["level"], name: "index_hieradata_on_level"
  end

  create_table "nodes", force: :cascade do |t|
    t.string "name"
    t.string "primary_key"
    t.string "code_environment"
    t.jsonb "classes"
    t.jsonb "trusted_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_nodes_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "primary_key"
    t.string "email"
    t.string "role"
    t.string "temp_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_users_on_username"
  end

end

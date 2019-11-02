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

ActiveRecord::Schema.define(version: 2019_10_27_223757) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "name"
    t.jsonb "description"
    t.string "icon_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "activity_associations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "activity_id", null: false
    t.uuid "associated_id", null: false
    t.integer "kind", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_activity_associations_on_activity_id"
    t.index ["associated_id"], name: "index_activity_associations_on_associated_id"
  end

  create_table "activity_clubs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "activity_id", null: false
    t.uuid "club_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_activity_clubs_on_activity_id"
    t.index ["club_id"], name: "index_activity_clubs_on_club_id"
  end

  create_table "club_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "club_id", null: false
    t.uuid "user_id", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "position"
    t.index ["club_id", "user_id"], name: "index_club_users_on_club_id_and_user_id", unique: true
    t.index ["club_id"], name: "index_club_users_on_club_id"
    t.index ["user_id"], name: "index_club_users_on_user_id"
  end

  create_table "clubs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "venue_id"
    t.jsonb "name", default: {}
    t.string "website"
    t.string "email"
    t.string "phone"
    t.string "national_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "kind", default: 0, null: false
    t.jsonb "long_name", default: {}
    t.boolean "visible_email"
    t.boolean "visible_phone"
    t.boolean "visible_national_id"
    t.string "logo_url"
    t.index ["venue_id"], name: "index_clubs_on_venue_id"
  end

  create_table "discipline_happening_tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "discipline_happening_id", null: false
    t.uuid "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discipline_happening_id"], name: "index_discipline_happening_tags_on_discipline_happening_id"
    t.index ["tag_id"], name: "index_discipline_happening_tags_on_tag_id"
  end

  create_table "discipline_happenings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "discipline_id", null: false
    t.uuid "happening_id", null: false
    t.jsonb "name", default: {}
    t.integer "gender", default: 0, null: false
    t.integer "distance_m"
    t.integer "elevation_m"
    t.integer "max_time_s"
    t.integer "age_min"
    t.integer "age_max"
    t.integer "price_without_discount_cents", default: 0, null: false
    t.string "price_without_discount_currency", default: "USD", null: false
    t.datetime "start_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "description", default: {}
    t.index ["discipline_id"], name: "index_discipline_happenings_on_discipline_id"
    t.index ["happening_id"], name: "index_discipline_happenings_on_happening_id"
  end

  create_table "discipline_requirements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "discipline_id", null: false
    t.uuid "requirement_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discipline_id"], name: "index_discipline_requirements_on_discipline_id"
    t.index ["requirement_id"], name: "index_discipline_requirements_on_requirement_id"
  end

  create_table "disciplines", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "activity_id", null: false
    t.jsonb "name", default: {}
    t.integer "number_of_crew", default: 1, null: false
    t.integer "number_of_relays", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_disciplines_on_activity_id"
    t.index ["name"], name: "index_disciplines_on_name", unique: true
  end

  create_table "happenings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "venue_id", null: false
    t.uuid "club_id", null: false
    t.jsonb "name", default: {}
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.string "website"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "description", default: {}
    t.string "recurrence"
    t.index ["club_id"], name: "index_happenings_on_club_id"
    t.index ["venue_id"], name: "index_happenings_on_venue_id"
  end

  create_table "requirements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "kind"
    t.jsonb "name", default: {}
    t.jsonb "description", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "name", default: {}
    t.integer "kind"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "locale", default: "", null: false
    t.string "initial_referer"
    t.string "provider"
    t.string "uid"
    t.string "picture_url"
    t.boolean "superadmin", default: false, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "club_id"
    t.index ["club_id"], name: "index_users_on_club_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "venues", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "name", default: {}
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "zip"
    t.boolean "is_a_city"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["latitude", "longitude"], name: "index_venues_on_latitude_and_longitude"
  end

  add_foreign_key "activity_associations", "activities"
  add_foreign_key "activity_associations", "activities", column: "associated_id"
  add_foreign_key "activity_clubs", "activities"
  add_foreign_key "activity_clubs", "clubs"
  add_foreign_key "club_users", "clubs"
  add_foreign_key "club_users", "users"
  add_foreign_key "clubs", "venues"
  add_foreign_key "discipline_happening_tags", "discipline_happenings"
  add_foreign_key "discipline_happening_tags", "tags"
  add_foreign_key "discipline_happenings", "disciplines"
  add_foreign_key "discipline_happenings", "happenings"
  add_foreign_key "discipline_requirements", "disciplines"
  add_foreign_key "discipline_requirements", "requirements"
  add_foreign_key "disciplines", "activities"
  add_foreign_key "happenings", "clubs"
  add_foreign_key "happenings", "venues"
  add_foreign_key "users", "clubs"
end

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

ActiveRecord::Schema.define(version: 20190724020924) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "catalan_towns", force: :cascade do |t|
    t.string  "code",              null: false
    t.string  "name",              null: false
    t.integer "comarca_code",      null: false
    t.string  "comarca_name",      null: false
    t.string  "amb"
    t.string  "vegueria_code",     null: false
    t.string  "vegueria_name",     null: false
    t.integer "province_code",     null: false
    t.string  "province_name",     null: false
    t.integer "male_population"
    t.integer "female_population"
    t.integer "total_population"
    t.index ["code"], name: "index_catalan_towns_on_code", using: :btree
    t.index ["name"], name: "index_catalan_towns_on_name", unique: true, using: :btree
  end

  create_table "catalan_towns_supra_municipalities", id: false, force: :cascade do |t|
    t.integer "catalan_town_id",       null: false
    t.integer "supra_municipality_id", null: false
    t.index ["catalan_town_id", "supra_municipality_id"], name: "index_catalan_towns_supra_municipalities", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collaborations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.integer  "frequency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_type"
    t.integer  "ccc_entity"
    t.integer  "ccc_office"
    t.integer  "ccc_dc"
    t.bigint   "ccc_account"
    t.string   "iban_account"
    t.string   "iban_bic"
    t.datetime "deleted_at"
    t.integer  "status",                  default: 0
    t.string   "redsys_identifier"
    t.datetime "redsys_expiration"
    t.string   "non_user_document_vatid"
    t.string   "non_user_email"
    t.text     "non_user_data"
    t.boolean  "for_autonomy_cc"
    t.boolean  "for_town_cc"
    t.boolean  "for_island_cc"
    t.index ["deleted_at"], name: "index_collaborations_on_deleted_at", using: :btree
    t.index ["non_user_document_vatid"], name: "index_collaborations_on_non_user_document_vatid", using: :btree
    t.index ["non_user_email"], name: "index_collaborations_on_non_user_email", using: :btree
  end

  create_table "districts", force: :cascade do |t|
    t.string  "name"
    t.integer "code"
    t.index ["code"], name: "index_districts_on_code", unique: true, using: :btree
  end

  create_table "districts_provinces", id: false, force: :cascade do |t|
    t.integer "district_id", null: false
    t.integer "province_id", null: false
    t.index ["district_id", "province_id"], name: "index_districts_provinces_on_district_id_and_province_id", using: :btree
  end

  create_table "districts_veguerias", id: false, force: :cascade do |t|
    t.integer "district_id", null: false
    t.integer "vegueria_id", null: false
    t.index ["district_id", "vegueria_id"], name: "index_districts_veguerias_on_district_id_and_vegueria_id", using: :btree
  end

  create_table "election_location_questions", force: :cascade do |t|
    t.integer "election_location_id"
    t.text    "title"
    t.text    "description"
    t.string  "voting_system"
    t.string  "layout"
    t.integer "winners"
    t.integer "minimum"
    t.integer "maximum"
    t.boolean "random_order"
    t.string  "totals"
    t.string  "options_headers"
    t.text    "options"
  end

  create_table "election_locations", force: :cascade do |t|
    t.integer  "election_id"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agora_version"
    t.string   "override"
    t.text     "title"
    t.string   "layout"
    t.text     "description"
    t.string   "share_text"
    t.string   "theme"
    t.integer  "new_agora_version"
  end

  create_table "elections", force: :cascade do |t|
    t.string   "title"
    t.integer  "agora_election_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "close_message"
    t.integer  "scope"
    t.string   "info_url"
    t.string   "server"
    t.datetime "user_created_at_max"
    t.integer  "priority"
    t.string   "info_text"
    t.integer  "flags"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.date     "starts_at"
    t.date     "ends_at"
    t.boolean  "is_institutional", default: false
    t.boolean  "has_location",     default: false
    t.integer  "location_type"
    t.string   "description"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "territory_id"
    t.string   "territory_type"
    t.index ["territory_id", "territory_type"], name: "index_groups_on_territory_id_and_territory_type", using: :btree
  end

  create_table "microcredit_loans", force: :cascade do |t|
    t.integer  "microcredit_id"
    t.integer  "amount"
    t.integer  "user_id"
    t.text     "user_data"
    t.datetime "confirmed_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "counted_at"
    t.string   "ip"
    t.string   "document_vatid"
    t.datetime "discarded_at"
    t.datetime "returned_at"
    t.integer  "transferred_to_id"
    t.index ["document_vatid"], name: "index_microcredit_loans_on_document_vatid", using: :btree
    t.index ["ip"], name: "index_microcredit_loans_on_ip", using: :btree
    t.index ["microcredit_id"], name: "index_microcredit_loans_on_microcredit_id", using: :btree
  end

  create_table "microcredits", force: :cascade do |t|
    t.string   "title"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "reset_at"
    t.text     "limits"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "account_number"
    t.string   "agreement_link"
    t.string   "contact_phone"
    t.integer  "total_goal"
    t.string   "slug"
    t.text     "subgoals"
    t.string   "renewal_terms_file_name"
    t.string   "renewal_terms_content_type"
    t.integer  "renewal_terms_file_size"
    t.datetime "renewal_terms_updated_at"
    t.string   "budget_link"
    t.index ["slug"], name: "index_microcredits_on_slug", unique: true, using: :btree
  end

  create_table "notice_registrars", force: :cascade do |t|
    t.string   "registration_id"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notices", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.string   "link"
    t.datetime "final_valid_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
  end

  create_table "online_verification_documents", force: :cascade do |t|
    t.integer  "upload_id",                    null: false
    t.string   "scanned_picture_file_name"
    t.string   "scanned_picture_content_type"
    t.integer  "scanned_picture_file_size"
    t.datetime "scanned_picture_updated_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["upload_id"], name: "index_online_verification_documents_on_upload_id", using: :btree
  end

  create_table "online_verification_events", force: :cascade do |t|
    t.string   "type",        null: false
    t.integer  "verified_id", null: false
    t.integer  "verifier_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["verified_id"], name: "index_online_verification_events_on_verified_id", using: :btree
  end

  create_table "online_verification_issues", force: :cascade do |t|
    t.integer  "report_id"
    t.integer  "label_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label_id"], name: "index_online_verification_issues_on_label_id", using: :btree
    t.index ["report_id"], name: "index_online_verification_issues_on_report_id", using: :btree
  end

  create_table "online_verification_labels", force: :cascade do |t|
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "status"
    t.datetime "payable_at"
    t.datetime "payed_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "reference"
    t.integer  "amount"
    t.boolean  "first"
    t.integer  "payment_type"
    t.string   "payment_identifier"
    t.text     "payment_response"
    t.string   "town_code"
    t.string   "autonomy_code"
    t.string   "island_code"
    t.index ["parent_id"], name: "index_orders_on_parent_id", using: :btree
  end

  create_table "positions", force: :cascade do |t|
    t.string   "name"
    t.integer  "position_type"
    t.integer  "group_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "downloader",    default: false
    t.index ["group_id"], name: "index_positions_on_group_id", using: :btree
  end

  create_table "positions_users", id: false, force: :cascade do |t|
    t.integer "position_id"
    t.integer "user_id"
    t.index ["position_id"], name: "index_positions_users_on_position_id", using: :btree
    t.index ["user_id"], name: "index_positions_users_on_user_id", using: :btree
  end

  create_table "provinces", force: :cascade do |t|
    t.string  "name"
    t.integer "code"
    t.index ["code"], name: "index_provinces_on_code", unique: true, using: :btree
  end

  create_table "provinces_veguerias", id: false, force: :cascade do |t|
    t.integer "province_id", null: false
    t.integer "vegueria_id", null: false
    t.index ["province_id", "vegueria_id"], name: "index_provinces_veguerias_on_province_id_and_vegueria_id", using: :btree
  end

  create_table "report_groups", force: :cascade do |t|
    t.string   "title"
    t.text     "proc"
    t.integer  "width"
    t.string   "label"
    t.string   "data_label"
    t.text     "whitelist"
    t.text     "blacklist"
    t.integer  "minimum"
    t.string   "minimum_label"
    t.string   "visualization"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", force: :cascade do |t|
    t.string   "title"
    t.text     "query"
    t.text     "main_group"
    t.text     "groups"
    t.text     "results"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "version_at"
  end

  create_table "simple_captcha_data", force: :cascade do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["key"], name: "idx_key", using: :btree
  end

  create_table "spam_filters", force: :cascade do |t|
    t.string   "name"
    t.text     "code"
    t.text     "data"
    t.string   "query"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supra_municipalities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                    default: "", null: false
    t.string   "encrypted_password",       default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "born_at"
    t.boolean  "wants_newsletter"
    t.integer  "document_type"
    t.string   "document_vatid"
    t.boolean  "admin"
    t.string   "address"
    t.string   "town"
    t.string   "province"
    t.string   "postal_code"
    t.string   "country"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "phone"
    t.string   "sms_confirmation_token"
    t.datetime "confirmation_sms_sent_at"
    t.datetime "sms_confirmed_at"
    t.integer  "failed_attempts",          default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "circle"
    t.datetime "deleted_at"
    t.string   "unconfirmed_phone"
    t.boolean  "wants_participation"
    t.string   "vote_town"
    t.integer  "flags",                    default: 0,  null: false
    t.datetime "participation_team_at"
    t.integer  "district"
    t.integer  "verified_by_id"
    t.datetime "verified_at"
    t.datetime "sms_check_at"
    t.string   "vote_district"
    t.string   "gender_identity"
    t.integer  "verified_online_by_id"
    t.datetime "verified_online_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["deleted_at", "document_vatid"], name: "index_users_on_deleted_at_and_document_vatid", unique: true, using: :btree
    t.index ["deleted_at", "email"], name: "index_users_on_deleted_at_and_email", unique: true, using: :btree
    t.index ["deleted_at", "phone"], name: "index_users_on_deleted_at_and_phone", unique: true, using: :btree
    t.index ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
    t.index ["document_vatid"], name: "index_users_on_document_vatid", using: :btree
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["flags"], name: "index_users_on_flags", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["sms_confirmation_token"], name: "index_users_on_sms_confirmation_token", unique: true, using: :btree
    t.index ["vote_town"], name: "index_users_on_vote_town", using: :btree
  end

  create_table "veguerias", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.index ["code"], name: "index_veguerias_on_code", unique: true, using: :btree
  end

  create_table "verification_centers", force: :cascade do |t|
    t.string   "name"
    t.string   "street"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "postalcode"
    t.string   "city"
  end

  create_table "verification_slots", force: :cascade do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "verification_center_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.index ["user_id"], name: "index_verification_slots_on_user_id", using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "election_id"
    t.string   "voter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_votes_on_deleted_at", using: :btree
  end

  add_foreign_key "online_verification_documents", "users", column: "upload_id"
  add_foreign_key "online_verification_events", "users", column: "verified_id"
  add_foreign_key "online_verification_events", "users", column: "verifier_id"
  add_foreign_key "online_verification_issues", "online_verification_events", column: "report_id"
  add_foreign_key "online_verification_issues", "online_verification_labels", column: "label_id"
  add_foreign_key "positions", "groups"
  add_foreign_key "users", "users", column: "verified_online_by_id"
  add_foreign_key "verification_slots", "users"
end

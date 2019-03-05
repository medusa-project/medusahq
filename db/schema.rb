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

ActiveRecord::Schema.define(version: 2019_03_05_230434) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "collections", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "title", null: false
    t.text "description"
    t.text "description_html"
    t.string "access_url"
    t.string "external_id"
    t.boolean "published", default: false, null: false
    t.boolean "ongoing", default: true, null: false
    t.string "representative_image_id", limit: 40
    t.string "representative_item_id", limit: 40
    t.boolean "harvestable", default: false, null: false
    t.string "contentdm_alias"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "private_description"
    t.string "physical_collection_url"
    t.index ["contentdm_alias"], name: "index_collections_on_contentdm_alias", unique: true
    t.index ["external_id"], name: "index_collections_on_external_id"
    t.index ["harvestable"], name: "index_collections_on_harvestable"
    t.index ["ongoing"], name: "index_collections_on_ongoing"
    t.index ["published"], name: "index_collections_on_published"
    t.index ["title"], name: "index_collections_on_title"
    t.index ["uuid"], name: "index_collections_on_uuid", unique: true
  end

end

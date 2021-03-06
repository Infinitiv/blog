# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141031183518) do

  create_table "articles", force: true do |t|
    t.string   "title",      default: "",    null: false
    t.text     "content"
    t.boolean  "published",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "asks", force: true do |t|
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: true do |t|
    t.integer  "article_id"
    t.string   "title",      default: "", null: false
    t.string   "mime_type",  default: "", null: false
    t.binary   "data"
    t.binary   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["article_id"], name: "index_attachments_on_article_id"

  create_table "comments", force: true do |t|
    t.integer  "article_id"
    t.text     "content"
    t.boolean  "published",  default: false, null: false
    t.boolean  "boolean",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id"

  create_table "users", force: true do |t|
    t.string   "login",           default: "", null: false
    t.string   "password_digest", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

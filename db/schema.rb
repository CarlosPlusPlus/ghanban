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

ActiveRecord::Schema.define(version: 20150321141106) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "boards_repos", force: :cascade do |t|
    t.integer "board_id"
    t.integer "repo_id"
  end

  add_index "boards_repos", ["board_id"], name: "index_boards_repos_on_board_id", using: :btree
  add_index "boards_repos", ["repo_id"], name: "index_boards_repos_on_repo_id", using: :btree

  create_table "boards_users", id: false, force: :cascade do |t|
    t.integer "board_id"
    t.integer "user_id"
  end

  add_index "boards_users", ["board_id"], name: "index_boards_users_on_board_id", using: :btree
  add_index "boards_users", ["user_id"], name: "index_boards_users_on_user_id", using: :btree

  create_table "issues", force: :cascade do |t|
    t.integer  "repo_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "github_id"
    t.integer  "number"
    t.string   "title"
    t.text     "body"
    t.string   "url"
    t.string   "html_url"
    t.integer  "comments"
    t.string   "comments_url"
    t.datetime "github_created_at"
    t.datetime "github_updated_at"
    t.datetime "closed_at"
    t.string   "organization"
    t.string   "repo_name"
    t.string   "state"
    t.integer  "user_gh_id"
    t.string   "user_gh_login"
    t.integer  "assignee_gh_id"
    t.string   "assignee_gh_login"
    t.string   "assignee_avatar"
    t.integer  "milestone_id"
    t.string   "milestone_url"
    t.string   "milestone_title"
    t.string   "category"
    t.string   "priority"
    t.string   "status"
    t.string   "team"
    t.string   "type"
    t.integer  "size"
  end

  create_table "issues_labels", force: :cascade do |t|
    t.integer "issue_id"
    t.integer "label_id"
  end

  add_index "issues_labels", ["issue_id"], name: "index_issues_labels_on_issue_id", using: :btree
  add_index "issues_labels", ["label_id"], name: "index_issues_labels_on_label_id", using: :btree

  create_table "labels", force: :cascade do |t|
    t.string   "name"
    t.string   "color"
    t.string   "url"
    t.integer  "repo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repos", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "username"
  end

end

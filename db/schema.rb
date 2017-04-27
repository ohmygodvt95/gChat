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

ActiveRecord::Schema.define(version: 20170424154019) do

  create_table "mentions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "room_id"
    t.integer  "message_id"
    t.integer  "mention_user_id"
    t.boolean  "is_read",         default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["mention_user_id"], name: "index_mentions_on_mention_user_id"
    t.index ["message_id"], name: "index_mentions_on_message_id"
    t.index ["room_id"], name: "index_mentions_on_room_id"
    t.index ["user_id"], name: "index_mentions_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "room_id"
    t.string   "message_type", default: "text"
    t.text     "raw_content"
    t.text     "content"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "room_id"
    t.string   "content"
    t.boolean  "is_read",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["room_id"], name: "index_notifications_on_room_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "user_request_id"
    t.integer  "user_receiver_id"
    t.boolean  "is_accept",        default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["user_receiver_id"], name: "index_relationships_on_user_receiver_id"
    t.index ["user_request_id"], name: "index_relationships_on_user_request_id"
  end

  create_table "replies", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "room_id"
    t.integer  "message_id"
    t.integer  "reply_user_id"
    t.integer  "reply_message_id"
    t.boolean  "is_read",          default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["message_id"], name: "index_replies_on_message_id"
    t.index ["reply_message_id"], name: "index_replies_on_reply_message_id"
    t.index ["reply_user_id"], name: "index_replies_on_reply_user_id"
    t.index ["room_id"], name: "index_replies_on_room_id"
    t.index ["user_id"], name: "index_replies_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "avatar"
    t.string   "room_type",   default: "private"
    t.text     "description"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "room_id"
    t.text     "content",    null: false
    t.datetime "due_date",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_tasks_on_room_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "user_rooms", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "room_id"
    t.integer  "last_message", default: 0
    t.boolean  "is_admin",     default: false
    t.datetime "focus_at"
    t.boolean  "is_accept",    default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["room_id"], name: "index_user_rooms_on_room_id"
    t.index ["user_id"], name: "index_user_rooms_on_user_id"
  end

  create_table "user_tasks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.boolean  "is_completed", default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["task_id"], name: "index_user_tasks_on_task_id"
    t.index ["user_id"], name: "index_user_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "avatar"
    t.string   "organization"
    t.string   "division"
    t.string   "title"
    t.string   "phone"
    t.string   "url"
    t.text     "description"
    t.boolean  "is_online",              default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

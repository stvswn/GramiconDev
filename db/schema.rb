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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120704191630) do

  create_table "credit_transactions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.integer  "message_id"
    t.string   "action"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "credit_transactions", ["user_id"], :name => "index_credit_transactions_on_user_id"

  create_table "folders", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "interactions", :force => true do |t|
    t.integer  "message_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "messages", :force => true do |t|
    t.text     "body",                                   :null => false
    t.integer  "sender_id",                              :null => false
    t.integer  "recipient_id",                           :null => false
    t.integer  "folder_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "state",           :default => "new",     :null => false
    t.integer  "credits",         :default => 0,         :null => false
    t.string   "type",            :default => "Message", :null => false
    t.integer  "responded_to_id"
    t.integer  "interaction_id"
  end

  add_index "messages", ["credits"], :name => "index_messages_on_credits"
  add_index "messages", ["state"], :name => "index_messages_on_state"

  create_table "ratings", :force => true do |t|
    t.integer  "user_id",        :null => false
    t.integer  "interaction_id", :null => false
    t.integer  "rater_id"
    t.boolean  "value"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"
  add_index "ratings", ["value"], :name => "index_ratings_on_value"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                  :default => "", :null => false
    t.date     "dob"
    t.string   "gender"
    t.string   "zip_code"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "credits",                :default => 0,  :null => false
    t.integer  "ratingcache"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

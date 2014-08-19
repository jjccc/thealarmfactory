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

ActiveRecord::Schema.define(:version => 20140417211652) do

  create_table "alarms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.integer  "samples_count",                     :default => 0,     :null => false
    t.boolean  "has_notifications",                 :default => false, :null => false
    t.string   "description",       :limit => 600
    t.string   "condition",         :limit => 1000
    t.integer  "user_id",                           :default => 0,     :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "alarm_id"
    t.integer  "sample_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "operations", :force => true do |t|
    t.integer  "alarm_id",                      :null => false
    t.integer  "operator_id",                   :null => false
    t.string   "first_operand",  :limit => 100
    t.string   "second_operand", :limit => 100
    t.integer  "position",                      :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "operator_types", :force => true do |t|
    t.string   "name",       :limit => 100, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "operators", :force => true do |t|
    t.string   "name",                            :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "operands",         :default => 1, :null => false
    t.string   "symbol"
    t.integer  "operator_type_id", :default => 1, :null => false
  end

  create_table "plans", :force => true do |t|
    t.string   "name",         :limit => 100,                    :null => false
    t.integer  "position",                                       :null => false
    t.float    "price"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "alarms_text",  :limit => 200
    t.string   "samples_text", :limit => 200
    t.string   "support_text", :limit => 200
    t.boolean  "is_default",                  :default => false, :null => false
  end

  create_table "receivers", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "alarm_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "samples", :force => true do |t|
    t.float    "value",      :null => false
    t.integer  "alarm_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",  :null => false
    t.string   "encrypted_password",     :default => "",  :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "api_token",              :default => "0", :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

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

ActiveRecord::Schema.define(:version => 20140613155602) do

  create_table "admin_users", :force => true do |t|
    t.string   "username"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "role"
  end

  create_table "answer_reviews", :force => true do |t|
    t.string   "content"
    t.integer  "flag"
    t.integer  "question_review_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.string   "content"
    t.integer  "flag"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "credits", :force => true do |t|
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "username"
    t.string   "provider"
    t.string   "email"
    t.integer  "question_number"
  end

  create_table "degrees", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tag_id"
    t.integer  "type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "point"
    t.integer  "accumulate_point"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "question_results", :force => true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.string   "result"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "tag_id"
    t.integer  "level"
    t.integer  "try_time",    :default => 0
  end

  add_index "question_results", ["question_id"], :name => "index_question_results_on_question_id"
  add_index "question_results", ["user_id"], :name => "index_question_results_on_user_id"

  create_table "question_reviews", :force => true do |t|
    t.string   "content"
    t.integer  "tag_id"
    t.integer  "level"
    t.integer  "time"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "questions", :force => true do |t|
    t.string   "content",                   :limit => 2000
    t.integer  "tag_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "level"
    t.integer  "time"
    t.string   "html_content",              :limit => 2000
    t.string   "url"
    t.string   "explaination",              :limit => 2000
    t.string   "explaination_html_content", :limit => 3000
    t.string   "explaination_url"
  end

  create_table "recently_update_questions", :force => true do |t|
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "tag_id"
    t.integer  "question_id"
  end

  create_table "recently_update_tags", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "tag_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "content"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "image"
    t.string   "explaination"
    t.string   "explaination_url"
  end

  create_table "user_reports", :force => true do |t|
    t.string   "username"
    t.string   "provider"
    t.integer  "question_id"
    t.string   "content"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "user_sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_sessions", ["session_id"], :name => "index_user_sessions_on_session_id"
  add_index "user_sessions", ["updated_at"], :name => "index_user_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "name"
    t.string   "uuid"
    t.string   "token"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "avatar",            :limit => 1000
    t.string   "persistence_token"
  end

end

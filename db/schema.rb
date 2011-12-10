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

ActiveRecord::Schema.define(:version => 20111210100843) do

  create_table "authors", :force => true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.string   "affiliation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors_books", :id => false, :force => true do |t|
    t.integer "author_id", :null => false
    t.integer "book_id",   :null => false
  end

  add_index "authors_books", ["author_id"], :name => "fk_authors_books_authors"
  add_index "authors_books", ["book_id"], :name => "fk_authors_books_books"

  create_table "authors_publications", :id => false, :force => true do |t|
    t.integer "author_id",      :null => false
    t.integer "publication_id", :null => false
  end

  add_index "authors_publications", ["author_id"], :name => "fk_authors_publications_authors"
  add_index "authors_publications", ["publication_id"], :name => "fk_authors_publications_publications"

  create_table "books", :force => true do |t|
    t.string   "title"
    t.string   "publisher"
    t.string   "editor"
    t.integer  "year"
    t.string   "isbn"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calls", :force => true do |t|
    t.integer  "conference_id"
    t.integer  "journal_id"
    t.integer  "book_id"
    t.date     "deadline"
    t.string   "url"
    t.string   "guest_editor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "calls", ["book_id"], :name => "fk_calls_books"
  add_index "calls", ["conference_id"], :name => "fk_calls_conferences"
  add_index "calls", ["journal_id"], :name => "fk_calls_journals"

  create_table "conferences", :force => true do |t|
    t.string   "name"
    t.date     "begin_date"
    t.date     "end_date"
    t.date     "deadline"
    t.date     "acceptance"
    t.date     "due"
    t.string   "submission_type"
    t.string   "url"
    t.string   "location"
    t.string   "proceedings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "journals", :force => true do |t|
    t.string   "name"
    t.string   "publisher"
    t.string   "issn"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publications", :force => true do |t|
    t.integer  "conference_id"
    t.integer  "journal_id"
    t.integer  "book_id"
    t.integer  "status"
    t.string   "history"
    t.string   "pdf"
    t.text     "abstract"
    t.string   "doi"
    t.integer  "pages"
    t.integer  "volume"
    t.integer  "number"
    t.string   "title"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "call_id"
  end

  add_index "publications", ["book_id"], :name => "fk_publications_books"
  add_index "publications", ["call_id"], :name => "fk_publications_calls"
  add_index "publications", ["conference_id"], :name => "fk_publications_conferences"
  add_index "publications", ["journal_id"], :name => "fk_publications_journals"

  create_table "publications_users", :id => false, :force => true do |t|
    t.integer "publication_id", :null => false
    t.integer "user_id",        :null => false
  end

  add_index "publications_users", ["publication_id"], :name => "fk_publications_users_publications"
  add_index "publications_users", ["user_id"], :name => "fk_publications_users_users"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "rolemask"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
  end

  add_index "users", ["author_id"], :name => "fk_users_authors"

end

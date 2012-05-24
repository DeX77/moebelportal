# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120524210600) do

  create_table "associations", :force => true do |t|
    t.integer "topic_map_id", :null => false
    t.integer "ttype_id"
  end

  create_table "item_identifiers", :force => true do |t|
    t.integer "topic_map_id",   :null => false
    t.string  "reference",      :null => false
    t.integer "construct_id"
    t.string  "construct_type"
  end

  create_table "names", :force => true do |t|
    t.integer "topic_id", :null => false
    t.integer "ttype_id"
    t.string  "value"
  end

  create_table "occurrences", :force => true do |t|
    t.integer "topic_id", :null => false
    t.integer "ttype_id"
    t.text    "value"
    t.string  "datatype"
  end

  create_table "roles", :force => true do |t|
    t.integer "association_id", :null => false
    t.integer "ttype_id"
    t.integer "topic_id"
  end

  create_table "scoped_objects_topics", :force => true do |t|
    t.integer "scoped_object_id"
    t.string  "scoped_object_type"
    t.integer "topic_id"
  end

  create_table "subject_identifiers", :force => true do |t|
    t.integer "topic_map_id", :null => false
    t.string  "reference",    :null => false
    t.integer "topic_id"
  end

  create_table "subject_locators", :force => true do |t|
    t.integer "topic_map_id", :null => false
    t.string  "reference",    :null => false
    t.integer "topic_id"
  end

  create_table "topic_maps", :force => true do |t|
    t.string "base_locator", :null => false
  end

  create_table "topics", :force => true do |t|
    t.integer "topic_map_id", :null => false
    t.integer "reified_id"
    t.string  "reified_type"
  end

  create_table "variants", :force => true do |t|
    t.integer "name_id",  :null => false
    t.text    "value"
    t.string  "datatype"
  end

end

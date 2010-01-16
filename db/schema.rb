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

ActiveRecord::Schema.define(:version => 12) do

  create_table "creatures", :force => true do |t|
    t.string   "name"
    t.string   "ctype"
    t.string   "gifts"
    t.integer  "frequency"
    t.integer  "offense"
    t.integer  "defense"
    t.integer  "tenacity"
    t.integer  "challenge_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "foes", :force => true do |t|
    t.integer  "game_id"
    t.string   "creature_id"
    t.string   "name"
    t.integer  "hstatus"
    t.integer  "estatus"
    t.integer  "mark_scratch"
    t.integer  "mark_hurt"
    t.integer  "mark_very_hurt"
    t.integer  "mark_incapacitated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "gold"
    t.integer  "round"
    t.integer  "stage"
    t.string   "name"
    t.integer  "status"
  end

  create_table "hero_items", :force => true do |t|
    t.integer  "hero_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hero_skills", :force => true do |t|
    t.integer  "hero_id"
    t.integer  "skill_id"
    t.integer  "ep"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "heros", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.string   "name"
    t.integer  "strength"
    t.integer  "dexterity"
    t.integer  "constitution"
    t.integer  "intelligence"
    t.integer  "hstatus"
    t.integer  "estatus"
    t.integer  "energy"
    t.integer  "offense_mod"
    t.integer  "defense_mod"
    t.integer  "games"
    t.integer  "rank"
    t.integer  "earned_ep"
    t.integer  "unspent_ep"
    t.integer  "mark_scratch"
    t.integer  "mark_hurt"
    t.integer  "mark_very_hurt"
    t.integer  "mark_incapacitated"
    t.integer  "defense_mod_animal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_attributes", :force => true do |t|
    t.integer  "item_id"
    t.string   "name"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "location"
    t.integer  "offense_skill_id"
    t.integer  "defense_skill_id"
    t.integer  "cost"
    t.integer  "evolves_item_id"
    t.integer  "devolves_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.binary  "server_url"
    t.string  "handle"
    t.binary  "secret"
    t.integer "issued"
    t.integer "lifetime"
    t.string  "assoc_type"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.string  "nonce"
    t.integer "created"
  end

  create_table "open_id_authentication_settings", :force => true do |t|
    t.string "setting"
    t.binary "value"
  end

  create_table "skill_attributes", :force => true do |t|
    t.integer  "skill_id"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", :force => true do |t|
    t.string   "name"
    t.integer  "dependant_skill_id"
    t.integer  "challenge_factor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "identity_url"
  end

end

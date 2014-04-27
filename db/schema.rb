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
    t.integer  "frequency",        :limit => 11
    t.integer  "offense",          :limit => 11
    t.integer  "defense",          :limit => 11
    t.integer  "tenacity",         :limit => 11
    t.integer  "challenge_rating", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "foes", :force => true do |t|
    t.integer  "game_id",            :limit => 11
    t.string   "creature_id"
    t.string   "name"
    t.integer  "hstatus",            :limit => 11
    t.integer  "estatus",            :limit => 11
    t.integer  "mark_scratch",       :limit => 11
    t.integer  "mark_hurt",          :limit => 11
    t.integer  "mark_very_hurt",     :limit => 11
    t.integer  "mark_incapacitated", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    :limit => 11
    t.integer  "gold",       :limit => 11
    t.integer  "round",      :limit => 11
    t.integer  "stage",      :limit => 11
    t.string   "name"
    t.integer  "status",     :limit => 11
  end

  create_table "hero_items", :force => true do |t|
    t.integer  "hero_id",    :limit => 11
    t.integer  "item_id",    :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hero_skills", :force => true do |t|
    t.integer  "hero_id",    :limit => 11
    t.integer  "skill_id",   :limit => 11
    t.integer  "ep",         :limit => 11
    t.integer  "level",      :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "heros", :force => true do |t|
    t.integer  "user_id",            :limit => 11
    t.integer  "game_id",            :limit => 11
    t.string   "name"
    t.integer  "strength",           :limit => 11
    t.integer  "dexterity",          :limit => 11
    t.integer  "constitution",       :limit => 11
    t.integer  "intelligence",       :limit => 11
    t.integer  "hstatus",            :limit => 11
    t.integer  "estatus",            :limit => 11
    t.integer  "energy",             :limit => 11
    t.integer  "offense_mod",        :limit => 11
    t.integer  "defense_mod",        :limit => 11
    t.integer  "games",              :limit => 11
    t.integer  "rank",               :limit => 11
    t.integer  "earned_ep",          :limit => 11
    t.integer  "unspent_ep",         :limit => 11
    t.integer  "mark_scratch",       :limit => 11
    t.integer  "mark_hurt",          :limit => 11
    t.integer  "mark_very_hurt",     :limit => 11
    t.integer  "mark_incapacitated", :limit => 11
    t.integer  "defense_mod_animal", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_attributes", :force => true do |t|
    t.integer  "item_id",    :limit => 11
    t.string   "name"
    t.integer  "value",      :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "location"
    t.integer  "offense_skill_id", :limit => 11
    t.integer  "defense_skill_id", :limit => 11
    t.integer  "cost",             :limit => 11
    t.integer  "evolves_item_id",  :limit => 11
    t.integer  "devolves_item_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.binary  "server_url"
    t.string  "handle"
    t.binary  "secret"
    t.integer "issued",     :limit => 11
    t.integer "lifetime",   :limit => 11
    t.string  "assoc_type"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.string  "nonce"
    t.integer "created", :limit => 11
  end

  create_table "open_id_authentication_settings", :force => true do |t|
    t.string "setting"
    t.binary "value"
  end

  create_table "skill_attributes", :force => true do |t|
    t.integer  "skill_id",   :limit => 11
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", :force => true do |t|
    t.string   "name"
    t.integer  "dependant_skill_id", :limit => 11
    t.integer  "challenge_factor",   :limit => 11
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

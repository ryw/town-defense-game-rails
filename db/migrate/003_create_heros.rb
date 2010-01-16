class CreateHeros < ActiveRecord::Migration
  def self.up
    create_table  :heros do |t|
      t.integer   :user_id
      t.integer   :game_id
      t.string    :name
      #attributes
      t.integer   :strength
      t.integer   :dexterity
      t.integer   :constitution
      t.integer   :intelligence
      #stats
      t.integer   :hstatus        #health status
      t.integer   :estatus        #engaged status
      t.integer   :energy
      t.integer   :offense_mod
      t.integer   :defense_mod
      t.integer   :games
      t.integer   :rank
      t.integer   :earned_ep
      t.integer   :unspent_ep
      t.integer   :mark_scratch
      t.integer   :mark_hurt
      t.integer   :mark_very_hurt
      t.integer   :mark_incapacitated
      #special combat
      t.integer   :defense_mod_animal
      t.timestamps 
    end
  end

  def self.down
    drop_table :heros
  end
end

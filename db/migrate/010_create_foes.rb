class CreateFoes < ActiveRecord::Migration
  def self.up
    create_table :foes do |t|
      t.integer   :game_id
      t.integer   :creature_id
      t.string    :name
      t.integer   :hstatus        #health status
      t.integer   :estatus        #engaged status
      t.integer   :mark_scratch
      t.integer   :mark_hurt
      t.integer   :mark_very_hurt
      t.integer   :mark_incapacitated
      t.timestamps
    end
  end

  def self.down
    drop_table :foes
  end
end

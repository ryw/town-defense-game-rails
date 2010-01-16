class CreateGames < ActiveRecord::Migration
  def self.up
    create_table  :games do |t|
      t.datetime  :created_at
      t.datetime  :updated_at
      t.integer   :user_id
      t.integer   :gold
      t.integer   :round
      t.integer   :stage
      t.string    :name
      t.integer   :status
      t.timestamps 
    end
  end

  def self.down
    drop_table :games
  end
end
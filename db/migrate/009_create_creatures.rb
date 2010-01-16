class CreateCreatures < ActiveRecord::Migration
  def self.up
    create_table :creatures do |t|
      t.string  :name
      t.string  :ctype
      t.string  :gifts
      t.integer :frequency
      t.integer :offense
      t.integer :defense
      t.integer :tenacity
      t.integer :challenge_rating   
      t.timestamps
    end
  end

  def self.down
    drop_table :creatures
  end
end
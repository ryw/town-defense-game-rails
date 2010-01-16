class CreateSkills < ActiveRecord::Migration
  def self.up
    create_table :skills do |t|
      t.string :name
      t.integer :dependant_skill_id
      t.integer :challenge_factor
      t.timestamps 
    end
  end

  def self.down
    drop_table :skills
  end
end

class CreateHeroSkills < ActiveRecord::Migration
  def self.up
    create_table :hero_skills do |t|
      t.integer :hero_id
      t.integer :skill_id
      t.integer :ep
      t.integer :level
      t.timestamps 
    end
  end

  def self.down
    drop_table :hero_skills
  end
end

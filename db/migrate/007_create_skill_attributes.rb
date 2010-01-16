class CreateSkillAttributes < ActiveRecord::Migration
  def self.up
    create_table :skill_attributes do |t|
      t.integer :skill_id
      t.string :name
      t.string :value
      t.timestamps 
    end
  end

  def self.down
    drop_table :skill_attributes
  end
end

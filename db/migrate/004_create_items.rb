class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.string :location
      t.integer :offense_skill_id
      t.integer :defense_skill_id
      t.integer :cost
      t.integer :evolves_item_id
      t.integer :devolves_item_id
      t.timestamps 
    end
  end

  def self.down
    drop_table :items
  end
end

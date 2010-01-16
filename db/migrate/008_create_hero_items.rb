class CreateHeroItems < ActiveRecord::Migration
  def self.up
    create_table :hero_items do |t|
      t.integer :hero_id
      t.integer :item_id
      t.timestamps 
    end
  end

  def self.down
    drop_table :hero_items
  end
end

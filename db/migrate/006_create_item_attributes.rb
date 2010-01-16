class CreateItemAttributes < ActiveRecord::Migration
  def self.up
    create_table :item_attributes do |t|
      t.integer :item_id
      t.string :name
      t.integer :value
      t.timestamps 
    end
  end

  def self.down
    drop_table :item_attributes
  end
end

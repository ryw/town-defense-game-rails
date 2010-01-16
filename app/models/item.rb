class Item < ActiveRecord::Base
  belongs_to :hero_item
  has_many :item_attributes
  belongs_to :evolves_to, :class_name => 'Item', :foreign_key => 'evolves_item_id'
  belongs_to :devolves_to, :class_name => 'Item', :foreign_key => 'devolves_item_id'
  belongs_to :offense_skill, :class_name => 'Skill', :foreign_key => 'offense_skill_id'
  belongs_to :defense_skill, :class_name => 'Skill', :foreign_key => 'defense_skill_id'
    
  def self.costs_under(gold)
    self.find(:all, :conditions => ["cost <= ?", gold], :order => "cost desc")
  end
end
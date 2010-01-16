class Skill < ActiveRecord::Base
  belongs_to :hero_skills
  has_many :skill_attributes
  belongs_to :dependant_skill, :class_name => 'Skill', :foreign_key => 'dependant_skill_id'
  
  WANDS         = find_by_name("wands")
  LONG_SWORDS   = Skill.find_by_name("long swords")
  SHORT_SWORDS  = Skill.find_by_name("short swords")
  GREAT_SWORDS  = Skill.find_by_name("great swords")
  POLE_ARMS     = Skill.find_by_name("pole arms")
  ARCHERY       = find_by_name("archery") 
  THROWN        = find_by_name("thrown weapons")
  BATTLE_AXES   = Skill.find_by_name("battle axes")

  WANDS_TITLES = 
    [ "Wandbreaker", "Wandflicker", "Wandholder", "Wandwaver", "Wandwielder", "Wandmaster", "Wandlord" ]
  LONG_SWORDS_TITLES = 
    [ "Woodwielder", "Tinwielder", "Ironwielder", "Bronzewielder", "Steelwielder", "Goldwielder", "Diamondwielder" ]
  SHORT_SWORDS_TITLES = 
    [ "Thief", "Cutpurse", "Robber", "Shadow", "Assassin", "Whisper", "Ghost" ]          
  GREAT_SWORDS_TITLES = 
    [ "Swordbreaker", "Swordwaver", "Swordholder", "Swordwielder", "Swordmaster", "Swordduke", "Swordlord" ]
  POLE_ARMS_TITLES = 
    [ "Polebreaker", "Poleshaker", "Poleshaker", "Polewielder", "Polewielder", "Polemaster", "Polelord" ]
  ARCHERY_TITLES = 
    [ "Bowbreaker", "String Plucker", "Archer", "Archer", "Master Archer", "Archery Lord", "Archery King" ]    
  THROWN_TITLES = 
    [ "Pebblechucker", "Rocktosser", "Darter", "Darter", "Dart Master", "Master Thrower", "Deadeye" ]
  BATTLE_AXES_TITLES = 
    [ "Hacker", "Tree Chopper", "Axeman", "Axeman", "Master Axeman", "Axe Lord", "Battle King" ]

  def offense_attribute
    case self
      when WANDS    : :intelligence
      when ARCHERY  : :dexterity
      when THROWN   : :dexterity
      else            :strength
    end
  end
  
  def title(level)
    index = [level+3,6].min
    case self
      when WANDS        : WANDS_TITLES[index]
      when LONG_SWORDS  : LONG_SWORDS_TITLES[index]
      when SHORT_SWORDS : SHORT_SWORDS_TITLES[index]
      when GREAT_SWORDS : GREAT_SWORDS_TITLES[index]
      when POLE_ARMS    : POLE_ARMS_TITLES[index]
      when ARCHERY      : ARCHERY_TITLES[index]
      when THROWN       : THROWN_TITLES[index]
      when BATTLE_AXES  : BATTLE_AXES_TITLES[index]
    end
  end  
  
end

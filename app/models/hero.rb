class Hero < ActiveRecord::Base
    
  belongs_to  :user
  belongs_to  :game
  has_many    :hero_items
  has_many    :items, :through => :hero_items
  has_many    :hero_skills, :order => "level desc"
  has_many    :skills, :through => :hero_skills
    
  before_create :set_initial_values
  after_create :update_mods

  def self.top_active_heros
    self.find(:all, :conditions => "hstatus < #{Status::DEAD}", 
      :order => "rank desc, earned_ep desc", :limit => 20)
  end
    
  def self.top_dead_heros
    self.find(:all, :conditions => "hstatus = #{Status::DEAD}", 
      :order => "rank desc, earned_ep desc", :limit => 20)
  end

  def current_offense_skill_mod
    if current_offense_skill
      send(current_offense_skill.offense_attribute)
    else
      0
    end
  end

  def update_mods
    update_attribute(:offense_mod, hstatus_mod + energy_mod + base_offense_mod + current_offense_skill_mod)
    update_attribute(:defense_mod, hstatus_mod + energy_mod + base_defense_mod + self.dexterity)
  end
  
  def current_offense_skill
    if item = self.items.find_by_location('right hand')
      item.offense_skill
    end
  end
  
  def current_defense_skill
    if item = self.items.find_by_location('left hand')
      item.defense_skill
    end
  end
  
  def increase_offense_skill(num)
    if current_offense_skill
      hero_skill = self.hero_skills.find_by_skill_id(self.current_offense_skill)
      hero_skill.gain_experience(num)
    else
      "<span class=\"rolldata\">No skill gain. Get a weapon!</span><br />"
    end
  end
  
  def increase_defense_skill(num)
    if current_defense_skill
      hero_skill = self.hero_skills.find_by_skill_id(self.current_defense_skill)
      hero_skill.gain_experience(num)
    else
      "<span class=\"rolldata\">No skill gain. Get a defense item!</span><br />"
    end
  end

  def eq
    result = ''
    self.items.each do |eq|
      result += "#{eq.location}: #{eq.name}<br />"
    end
    result.chomp "<br />"
  end
  
  def skills_list
    self.hero_skills.collect { |s| "#{s.skill.name}: #{s.level.to_ladder}" }.join '<br />'
  end

  def training_available?
    unspent_ep >= minimum_training_cost
  end  

  def minimum_training_cost
    training_costs = []
    training_costs << self.strength.attribute_training_cost
    training_costs << self.dexterity.attribute_training_cost
    training_costs << self.constitution.attribute_training_cost
    training_costs << self.intelligence.attribute_training_cost
    training_costs.min
  end
  
  def title
    current_offense_skill ? current_offense_skill.title(hero_skills.find_by_skill_id(current_offense_skill).level) : "Brawler"
  end

  def name_with_title
    "#{title} #{name}"
  end
    
  def gain_experience(modifier)
    ep = (1 + rand(Math::sqrt(modifier))).to_i
    message = "<span class=\"goodnews\">#{self.name} gained #{ep} experience point(s).</span><br />"      
    self.update_attribute(:earned_ep, self.earned_ep+ep)
    self.update_attribute(:unspent_ep, self.unspent_ep+ep)
    #maybe gain a rank
    rank = Math::sqrt(earned_ep).to_i
    if rank > self.rank
      message += "<span class=\"goodnews\">#{self.name} gained a rank!</span><br />"
      self.update_attribute(:rank, rank)
    end
    message
  end
  
  def wound(severity)
    message = ''
    case 
      when severity == 1 && mark_scratch < 3
        update_attribute(:mark_scratch, mark_scratch + 1)
        self.energy_loss([5+self.constitution,1].max)
        message += "#{name_with_title} was scratched.<br />"
      when severity == 1 && mark_scratch == 3 
        wound(2)
      when severity == 2 && mark_hurt == 0
        update_attribute(:mark_hurt, 1)
        update_attribute(:hstatus, Status::HURT)
        self.energy_loss([15+self.constitution,1].max)
        message += "<span class=\"badnews\">#{name_with_title} was hurt.</span><br />"
      when severity == 2 && mark_hurt == 1
        wound(3)
      when severity == 3 && mark_very_hurt == 0
        update_attribute(:mark_very_hurt, 1)
        update_attribute(:hstatus, Status::VERY_HURT)
        self.energy_loss([30+self.constitution,1].max)
        message += "<span class=\"badnews\">#{name_with_title} was hurt badly.</span><br />"
      when severity == 3 && mark_very_hurt == 1
        wound(4)
      when severity == 4 && mark_incapacitated == 0
        update_attribute(:mark_incapacitated, 1)
        update_attribute(:hstatus, Status::INCAPACITATED)
        self.energy_loss([99+self.constitution,1].max)
        message += "<span class=\"badnews\">#{name_with_title} has been knocked to the ground, and hangs on by a thread.</span><br />"
      when severity == 4 && mark_incapacitated == 1
        die
    update_mods
    end
  end
    
  def die
    update_attribute(:hstatus, Status::DEAD)
    update_attribute(:game_id, nil)
    "<span class=\"badnews\">#{self.name_with_title} has been killed!</span><br />"
  end
  
  def energy_loss(num)
    update_attribute(:energy, self.energy-num)
    update_mods
    "<span class=\"rolldata\">#{self.name_with_title} lost #{num} energy to #{self.energy}.</span><br />"
  end
  
  def energy_gain(num)
    update_attribute(:energy, [self.energy+num,100].min)
    update_mods
    "<span class=\"rolldata\">#{self.name_with_title} gained #{num} energy to #{self.energy}.</span><br />"
  end

  def return_to_deck(energy=100)
    self.game_id = nil
    self.hstatus = 1
    self.estatus = 0
    energy == 80 ? self.energy = 80 : self.energy = 100
    update_mods
    self.mark_scratch = self.mark_hurt = self.mark_very_hurt = self.mark_incapacitated = 0
    save!
  end
  
  def eq_change(item)
    message = ''
    if self.currently_filled_location_slots.include?(item.location)
      #sell current eq
      current_item = self.current_item_by_location(item.location)
      self.game.update_attribute(:gold, 
        self.game.gold + current_item.cost)
      self.hero_items.find_by_item_id(current_item).destroy
      message += "#{self.name} sold #{current_item.name} for #{current_item.cost} gold -- "
      message += self.apply_item_attributes(current_item, :remove)
    end
    self.items << item
    #if item has related skills that hero doesn't have, add it at -3
    if item.offense_skill
      if self.hero_skills.find_by_skill_id(item.offense_skill_id).nil?
          self.hero_skills << HeroSkill.new( 
            :skill_id => item.offense_skill_id, :level => -3, :ep => 0)
      end
    end
    if item.defense_skill
      if self.hero_skills.find_by_skill_id(item.defense_skill_id).nil?
          self.hero_skills << HeroSkill.new( 
            :skill_id => item.defense_skill_id, :level => -3, :ep => 0)
      end
    end
    message += "#{self.name} equips #{item.name} -- "
    message += self.apply_item_attributes(item, :add)
    self.update_mods
    return message
  end
  
  def apply_item_attributes(item, add_or_remove)
    message = ''
    item.item_attributes.each do |a|
      add_or_remove == :remove ? modifier = -1 : modifier = 1
      case a.name
        when 'strength'
          self.update_attribute(:strength, self.strength+(a.value*modifier))
          message += "Strength #{sprintf("%+d", a.value*modifier)} to #{sprintf("%+d",self.strength)}.<br />"
        when 'dexterity'
          self.update_attribute(:dexterity, self.dexterity+(a.value*modifier))
          message += "Dexterity #{sprintf("%+d", a.value*modifier)} to #{sprintf("%+d",self.dexterity)}.<br />"
        when 'constitution'
          self.update_attribute(:constitution, self.constitution+(a.value*modifier))
          message += "Constitution #{sprintf("%+d", a.value*modifier)} to #{sprintf("%+d",self.constitution)}.<br />"
        when 'intelligence'
          self.update_attribute(:intelligence, self.intelligence+(a.value*modifier))
          message += "Intelligence #{sprintf("%+d", a.value*modifier)} to #{sprintf("%+d",self.intelligence)}.<br />"
        when 'self_defense_animal'
          self.update_attribute(:defense_mod_animal, self.defense_mod_animal+(a.value*modifier))
          message += "Magical Protection from Animals #{sprintf("%+d", a.value*modifier)} to #{sprintf("%+d",self.defense_mod_animal)}.<br />"
      end
    end
    message += "No effect on stats.<br />" if message == ''
    self.update_mods
    return message
  end
  
  def current_item_by_location(location)
    items.find_by_location(location)
  end

  def currently_filled_location_slots
    result = []
    hero_items.each do |i|
      result << i.item.location
    end
    return result
  end

private
  def set_initial_values 
    self.rank = self.games = self.hstatus = self.estatus = 1
    self.energy = 100
    self.mark_scratch = self.mark_hurt = self.mark_very_hurt = self.mark_incapacitated = 0    
    self.earned_ep = self.unspent_ep = 0
    self.defense_mod_animal = 0
    self.strength = self.dexterity = self.constitution = self.intelligence = 0
    5.times do 
      case rand(4)
        when 0: self.strength += 1
        when 1: self.dexterity += 1
        when 2: self.constitution += 1
        when 3: self.intelligence += 1
      end
    end
    3.times do 
      case rand(4)
        when 0: self.strength -= 1
        when 1: self.dexterity -= 1
        when 2: self.constitution -= 1
        when 3: self.intelligence -= 1
      end
    end
  end

  def hstatus_mod
    Hstatus.mod(self.hstatus)
  end

  def energy_mod
    Energy.mod(self.energy)
  end
  
  def base_offense_mod
    item = self.items.find_by_location('right hand')
    item_self_offense = 0
    item_skill_level = -2
    if item
      item_attribute = item.item_attributes.find_by_name('self_offense')
      item_self_offense = item_attribute.value if item_attribute
      item_skill_level = self.hero_skills.find_by_skill_id(current_offense_skill).level
    end
    item_self_offense + item_skill_level
  end

  def base_defense_mod
    item = self.items.find_by_location('left hand')
    item_self_defense = 0
    item_skill_level = -2
    if item
      item_self_defense = item.item_attributes.find_by_name('self_defense').value
      item_skill_level = self.hero_skills.find_by_skill_id(current_defense_skill).level
    end
    item_self_defense + item_skill_level
  end

end
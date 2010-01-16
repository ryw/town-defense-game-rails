class HeroSkill < ActiveRecord::Base
  belongs_to :hero
  belongs_to :skill
  
  def gain_experience(num)
    message = "<span class=\"rolldata\">#{skill.name} has increased #{num} to #{ep+num}.</span><br />"
    update_attribute(:ep, ep + num)
    #maybe gain a rank    
    new_level = Math::log((ep+num)*10/skill.challenge_factor).to_i - 4
    if new_level > level
      message += "<span class=\"levelup\">#{skill.name} increased a level to #{new_level.to_ladder}!</span><br />"
      update_attribute(:level, new_level)
      self.hero.update_mods
    end
    message
  end
end
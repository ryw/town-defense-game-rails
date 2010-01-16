class Creature < ActiveRecord::Base
  has_many :foes
  
  def self.attract(challenge_factor)
    chance = challenge_factor < 3 ? 1 : rand(100)+[challenge_factor-5,0].max
    Creature.find(:all, :conditions => "frequency = #{freq(chance)}").random
  end
  
  def frequency_in_words
    case self.frequency
      when 1: 'common'
      when 2: 'rare'
      when 3: 'very rare'
    end
  end
  
  private
  
  def self.freq(chance)
    case chance
      when 0..70: 1
      when 71..84: 2
      else 3
    end    
  end
end
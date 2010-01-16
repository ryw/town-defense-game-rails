class Fixnum
  def to_ladder
    rating = case self
      when 8..1000:	'Legendary'
      when 7:	'Epic'
      when 6: 'Fantastic'
      when 5: 'Superb'
      when 4:	'Great'
      when 3:	'Good'
      when 2:	'Fair'
      when 1:	'Average'
      when 0:	'Mediocre'
      when -1:	'Poor'
      when -1000..-2:	'Terrible'
    end
    "#{rating} (#{sprintf("%+d",self)})"
  end
  
  def skill_training_cost
    case self
      when -3..-1: 1
      when 0..1000: (self+1)*(self+1)
    end
  end

  def attribute_training_cost
    self.skill_training_cost*3
  end
end
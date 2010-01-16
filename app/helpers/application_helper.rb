# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def hstatus(num)
    word = case num
      when 1: 'Healthy'
      when 2: 'Hurt'
      when 3: 'Very Hurt'
      when 4: 'Incapacitated'
      when 5: 'Dead'
    end
    "[#{word}]"
  end

  def skill_training_cost(num)
    case num
      when -3..-1: 1
      when 0..10: (num+1)*2
    end
  end

  def attribute_training_cost(num)
    skill_training_cost(num)*3
  end

end
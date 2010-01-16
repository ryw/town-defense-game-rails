class Foe < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :game
  belongs_to  :creature
  
  def before_create
    self.estatus = 2
    self.hstatus = 1
    self.mark_scratch = self.mark_hurt = self.mark_very_hurt = self.mark_incapacitated = 0    
  end

  def name_with_type
    "#{name} the #{creature.name}"
  end
  
  def hstatus_mod
    case self.hstatus
      when 1: 0
      when 2: -1
      when 3..5: -2
    end
  end

  def offense_mod
    hstatus_mod + self.creature.offense
  end
  
  def defense_mod
    hstatus_mod + self.creature.defense
  end

  def wound(severity)
    message = ''
    case 
      when severity == 1 && mark_scratch < 3
        update_attribute(:mark_scratch, mark_scratch + 1)
        message += "#{name_with_type} was scratched.<br />"
      when severity == 1 && mark_scratch == 3 
        wound(2)
      when severity == 2 && mark_hurt == 0
        update_attribute(:mark_hurt, 1)
        update_attribute(:hstatus, Status::HURT)
        message += "<span class=\"goodnews\">#{name_with_type} was hurt.</span><br />"
      when severity == 2 && mark_hurt == 1
        wound(3)
      when severity == 3 && mark_very_hurt == 0
        update_attribute(:mark_very_hurt, 1)
        update_attribute(:hstatus, Status::VERY_HURT)
        message += "<span class=\"goodnews\">#{name_with_type} was hurt badly.</span><br />"
      when severity == 3 && mark_very_hurt == 1
        wound(4)
      when severity == 4 && mark_incapacitated == 0
        update_attribute(:mark_incapacitated, 1)
        update_attribute(:hstatus, Status::INCAPACITATED)
        message += "<span class=\"goodnews\">#{name_with_type} has been knocked to the ground, and hangs on by a thread.</span><br />"
      when severity == 4 && mark_incapacitated == 1
        die
    end
  end
    
  def die
    self.destroy
    "<span class=\"goodnews\">#{name_with_type} has been killed!</span><br />"
  end 
end
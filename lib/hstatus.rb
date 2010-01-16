class Hstatus
  
  def self.mod(int) 
    case int
      when Status::UNHARMED       :  0
      when Status::HURT           : -1
      when Status::VERY_HURT      : -2
      when Status::INCAPACITATED  : -2
      when Status::DEAD           :  0
    end
  end
  
end

class Energy

  def self.mod(int)
    case int
      when 90..100:   2
      when 80..89:    1
      when 40..79:    0
      when 20..39:   -1
      when 10..19:   -2
      when 1..9:     -3
      else           -4
    end
  end  

end

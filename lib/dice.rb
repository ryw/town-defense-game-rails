module Dice
  def roll(num=4)
    result = 0
    num.times do |n|
      result = result + rand(3) -1
    end
    result
  end
end
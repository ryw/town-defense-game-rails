class ItemAttribute < ActiveRecord::Base
  belongs_to :item
  
  def friendly_name
    case name
      when 'self_offense':        "Bonus to base attack"
      when 'self_defense':        "Bonus to base defense"
      when 'self_defense_animal': "Bonus to base defense vs. animals"
    end
  end
end

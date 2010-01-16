class HeroItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :hero
end
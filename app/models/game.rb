class Game < ActiveRecord::Base
  include Names

  belongs_to  :user
  has_many    :heros
  has_many    :engaged_heros, :class_name => 'Hero',
              :conditions => "estatus = 1", :order => "rank desc, earned_ep desc"
  has_many    :observing_heros, :class_name => 'Hero',
              :conditions => "estatus = 2", :order => "rank desc, earned_ep desc"
  has_many    :foes, :class_name => 'Foe'
  has_many    :engaged_foes,  :class_name => 'Foe', :include => 'creature',
              :conditions => "estatus = 1", :order => "creatures.challenge_rating desc"
  has_many    :observing_foes,  :class_name => 'Foe', :include => 'creature',
              :conditions => "estatus = 2", :order => "creatures.challenge_rating desc"

  UNBALANCED = 3
  OVER = 0
  STAGES = [:h_attract, :h_add, :h_withdrawal, :shopping, :training,
            :c_attract, :c_add, :c_withdrawal, :battle ]

  def before_create
    self.round = 1
    self.stage = 0
    self.gold = 50
    self.status = 1
  end

  def gain_gold(modifier)
    earned_gold = (rand(10)+rand(10))*modifier + 10
    update_attribute(:gold, gold+earned_gold)
    "You gained #{earned_gold} gold!<br />"
  end

  def destroy
    super
    self.foes.each do |f|
      f.destroy
    end
    return_heros_to_deck
    self.user.reset_hero_energy
  end

  def over
    update_attribute(:status, OVER)
  end

  def return_heros_to_deck
    self.heros.each do |h|
      h.return_to_deck
    end
  end

  def total_power_balance
    total_heros = engaged_heros.count*2 + observing_heros.count
    total_foes = engaged_foes.count*2 + observing_foes.count
    total_foes.zero? ? UNBALANCED : total_heros/total_foes
  end

  def engaged_power_balance
    engaged_foes.empty? ? UNBALANCED : engaged_heros.count/engaged_foes.count
  end

  def h_attract
    message = ''
    candidates = []
    possibles = self.user.active_heros
    limit = possibles.count
    if possibles.count > 0
      candidates << possibles.random
      candidates << possibles.random
      candidates << possibles.random
    end
    candidates.uniq.each do |c|
      chance = rand(100) + (self.round*2)
      if chance > (c.earned_ep+20) or self.engaged_heros.count == 0
        c.game_id = self.id
        c.estatus = 2
        c.save
        message += "<p>#{c.name_with_title} has arrived to the battle and watches on."
        message += "<span class=\"rolldata\">#{chance} vs. #{c.rank*20}</span></p>"
      end
    end
    message
  end

  def h_add
    message = ''
    candidate = self.observing_heros.find(:all, :conditions => 'hstatus < 2').random
    chance = rand(100) + (self.round*2)
    if candidate
      if chance > (candidate.earned_ep+20) or self.engaged_heros.count == 0
        candidate.estatus = 1
        candidate.games = candidate.games + 1
        candidate.save
        message += "<p>#{candidate.name_with_title} has joined the fray! "
        message += "<span class=\"rolldata\">#{chance} vs. #{candidate.rank*30}</span></p>"
      end
    else
      message += "No heros observing!"
    end
  end

  def c_attract
    message = message ||= ''
    candidate = Creature.attract(self.round)
    chance = rand(100) + self.round
    if chance > 40 or self.engaged_foes.count == 0
      foe_name = name_generate
      puts candidate
      self.foes << Foe.new(:name => foe_name, :creature_id => candidate.id)
      message += "<p>#{foe_name} the #{candidate.name} has arrived to the battle and watches on. "
      message += "<span class=\"rolldata\">#{chance} vs. 33</span></p>"
    end
    c_attract if self.total_power_balance > 2
    message
  end
end

class GamesController < ApplicationController
  before_filter :login_required
  before_filter :find_game, :except => [:index, :new, :create]

  def index
    session[:game] = nil
    current_user.delete_dead_games
    @games = current_user.games.find(:all)
  end

  def show
    session[:game] = @game.id
    case @game.stage
      when 0: redirect_to h_attract_game_url(@game) if @game.round > 1
      when 1: redirect_to h_add_game_url(@game)
      when 2: redirect_to h_withdrawal_game_url(@game)
      when 3: redirect_to shopping_game_url(@game)
      when 4: redirect_to training_game_url(@game)
      when 5: redirect_to c_attract_game_url(@game)
      when 6: redirect_to c_add_game_url(@game)
      when 7: redirect_to c_withdrawal_game_url(@game)
      when 8: redirect_to battle_game_url(@game)
    end
    @gen_name = name_generate
  end

  def new
    @game = current_user.games.new
    session[:game] = @game.id
    if @game.save
      flash[:notice] = 'Game was successfully created.'
      redirect_to @game
    else
      flash[:error] = 'Error creating new game.'
      render :action => "new"
    end
  end

  def destroy
    @game.destroy
    redirect_to games_url
  end

  def scouting
  end

  def defense_setup
  end

  def h_attract
    @message = @game.h_attract
  end

  def h_add
    @message = @game.h_add
  end

  def h_withdrawal
    @engaged_heros = @game.engaged_heros
  end

  def shopping
    @hero = params[:hero_id] ? Hero.find(params[:hero_id]) : @game.engaged_heros.random
    @items = Item.costs_under(@game.gold)
    @items = @items - @hero.items
  end

  def training
    flash[:notice] = params[:message] if params[:message]
    @game.engaged_heros.find(:all, :conditions => 'unspent_ep > 0').each do |h|
      if h.training_available?
        @hero = h
        @training_available = true
      end
    end
  end

  def c_attract
    @message = @game.c_attract
  end

  def c_add
    @message = @message ||= ''
    candidate = @game.observing_foes.find(:first, :order => 'creatures.challenge_rating asc')
    chance = rand(100) + @game.round
    if candidate
      if chance > 40 or (@game.engaged_heros.count - @game.engaged_foes.count > 2) or @game.engaged_foes.count == 0
        candidate.estatus = 1
        candidate.save
        @message += "<p>#{candidate.name_with_type} has joined the fray! "
        @message += "<span class=\"rolldata\">#{chance} vs. 33</span></p>" 
      end
      @game.reload
    else
      @message += "No foes observing!"
    end
    c_add if @game.engaged_power_balance > 2
  end

  def c_withdrawal
    @engaged_foes = @game.engaged_foes
  end

  def battle
    @message = ''
    #heros attack
    @game.engaged_heros.each do |h|
      @message += h.energy_loss([5-h.constitution,1].max)
      if h.hstatus < 4 and @game.engaged_foes.count > 0 then
        #hero will attack some random foe
        f = @game.engaged_foes.random
        if f.hstatus == 4 then
          #if foe is incapicated, instant death
          @message += "#{h.name_with_title} slays the hapless #{f.name_with_type}.<br />"
          @game.engaged_foes.delete(f)
          @message += f.die
          @message += h.gain_experience(f.creature.challenge_rating)
          @message += @game.gain_gold(f.creature.challenge_rating)
        else
          h_roll = roll
          @message += "#{h.name_with_title} #{roll_result(h_roll + h.offense_mod)} attacks "
          f_roll = roll
          @message += "#{f.name_with_type} #{roll_result(f_roll + f.defense_mod)} "
          damage = h_roll + h.offense_mod - f_roll - f.defense_mod
          @message += h.increase_offense_skill(1)
          if damage > 0 then
            @message += case damage
              when 1..2: f.wound(1)
              when 3..4: f.wound(2)
              when 5..6: f.wound(3)
              when 7..8: f.wound(4)
              else
                @game.engaged_foes.delete(f)
                f.die
                @message += h.gain_experience(f.creature.challenge_rating)
                @message += @game.gain_gold(f.creature.challenge_rating)
            end
            @message += h.gain_experience(f.creature.challenge_rating*damage/3)
          end
        end
      end
    end
    #foes attack
    @game.engaged_foes.each do |f|
      if f.hstatus < 4 then
        #foe will attack some random hero
        h = @game.engaged_heros.random
        if h then
          @message += h.energy_loss([3-h.constitution,0].max)
          if h.hstatus == 4 then
            #if hero is incapicated, instant deeath
            @message += "#{f.name_with_type} slays the hapless #{h.name_with_title}.<br />"
            @message << h.die
            @game.engaged_heros.delete(h)
          else
            f_roll = roll
            @message += "#{f.name_with_type} #{roll_result(f_roll + f.offense_mod)} attacks "
            h_roll = roll
            @message += "#{h.name_with_title} #{roll_result(h_roll + h.defense_mod)} "
            damage = f_roll + f.offense_mod - h_roll - h.defense_mod
            @message += h.increase_defense_skill(1)
            if damage > 0 then
              @message << case damage
                when 1..2: h.wound(1)
                when 3..4: h.wound(2)
                when 5..6: h.wound(3)
                when 7..8: h.wound(4)
                else h.die
              end
            end
          end
        end
      end
    end
    #observing heros
    @game.observing_heros.each do |h|
      h.energy_gain([3,h.constitution+2].min)
    end
    @result = :success if @game.engaged_heros.count > 0
  end

  def find_game
    @game = Game.find(params[:id])
  end

  def next_stage
    @game.update_attribute(:stage, @game.stage+1)
    if @game.stage == 9
      @game.update_attribute(:round, @game.round+1)
      @game.update_attribute(:stage, 0)
    end
    redirect_to @game
  end

  private

  def roll_result(num)
    char = case num
      when -1000..1: "X"
      when 0:     "-"
      when 1..1000:  "O"
    end
    num = 1 if num == 0
    "<span class=\"roll#{char}\">#{char*num.abs}</span>"
  end
end

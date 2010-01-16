class HerosController < ApplicationController

  def create
    @game = Game.find(session[:game])
    @hero = @game.heros.new(params[:hero].merge({
      :user_id => current_user.id }))  
    @hero.save
    respond_to do |format|
      if @hero.save
        flash[:notice] = 'Hero was successfully created.'
        format.html { redirect_to h_attract_game_url(@game) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @game = Game.find(session[:game]) if session[:game]
    @hero = Hero.find(params[:id])
    session[:hero] = @hero.id
    @items = @hero.items
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def train_attribute
    hero = Hero.find(params[:hero_id])
    case params[:attribute]
      when 'strength'
        hero.unspent_ep = hero.unspent_ep - hero.strength.attribute_training_cost
        hero.strength = hero.strength + 1
        hero.offense_mod += 1
        hero.save
      when 'dexterity'
        hero.unspent_ep = hero.unspent_ep - hero.dexterity.attribute_training_cost
        hero.dexterity = hero.dexterity + 1
        hero.defense_mod += 1
        hero.save
      when 'constitution'
        hero.unspent_ep = hero.unspent_ep - hero.constitution.attribute_training_cost
        hero.constitution = hero.constitution + 1
        hero.defense_mod += 1
        hero.save
      when 'intelligence'
        hero.unspent_ep = hero.unspent_ep - hero.intelligence.attribute_training_cost
        hero.intelligence = hero.intelligence + 1
        hero.save
    end
    redirect_to training_game_url
  end

  def buy_item
    hero = Hero.find(params[:hero_id])
    item = Item.find(params[:item_id])
    message = hero.eq_change(item)
    game = Game.find(session[:game])
    game.update_attribute(:gold, game.gold - item.cost)
    redirect_to shopping_game_url(:message => message, :hero_id => params[:hero_id])
  end
  
  def withdraw
    hero = Hero.find(params[:hero_id])
    message = "#{hero.name_with_title} withdraws."
    if hero.hstatus < 2
      hero.estatus = 2
      hero.save
    else
      hero.return_to_deck(80)
    end
    redirect_to h_withdrawal_game_url(:message => message)    
  end
end
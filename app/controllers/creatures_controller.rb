class CreaturesController < ApplicationController
  def index
    @creatures = Creature.find(:all, :order => 'name')
  end
  def show
    @creature = Creature.find(params[:id])
  end
end

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include Dice
  include Names
end
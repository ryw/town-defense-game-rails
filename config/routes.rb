ActionController::Routing::Routes.draw do |map|
  
  map.resources :games, :member => {
    :h_attract => :get,
    :h_add => :get, 
    :h_withdrawal => :get, 
    :c_attract => :get, 
    :c_add => :get, 
    :c_withdrawal => :get,
    :battle => :get, 
    :shopping => :get, 
    :training  => :get,
    :next_stage => :post }

  map.resources :heros, :member => {
    :train_attribute => :get,
    :train_skill => :get,
    :buy_item => :get,
    :withdraw => :get }

  map.resources :users, :items, :creatures, :attack_groups

  map.open_id_complete 'sessions', :controller => 'sessions', :action => 'create',
    :requirements => { :method => :get }

  map.resource :sessions

  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.connect '', :controller => 'games', :action => 'index'

end
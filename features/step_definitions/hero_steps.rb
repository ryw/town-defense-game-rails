Given /^a new hero$/ do
  @hero = Hero.create!
end

When /^I inspect his basic attributes$/ do
  @strength = @hero.strength
  @dexterity = @hero.dexterity
  @constitution = @hero.constitution
  @intelligence = @hero.intelligence  
  @basic_attributes_variance = (!@strength.zero? or !@dexterity.zero? or !@constitution.zero? or !@intelligence.zero?)
  @basic_attributes_total = @strength + @dexterity + @constitution + @intelligence
  @energy = @hero.energy
end

Then /^I should see basic attribute values other than 0$/ do
  @basic_attributes_variance.should == true
end

Then /^Basic attributes should add up to 2$/ do
  @basic_attributes_total.should == 2
end

Then /^Energy should be 100$/ do
  @energy.should == 100
end

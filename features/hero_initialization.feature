Feature: Hero Initialization

  So that starting heros are differentiated
  As a user
  I want new heros to have randomized stats 

  Scenario: New Hero 

    Given a new hero
    When I inspect his basic attributes
    Then I should see basic attribute values other than 0 
    And Basic attributes should add up to 2
    And Energy should be 100

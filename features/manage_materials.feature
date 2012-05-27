Feature: Manage materials
  In order to use different materials
  the developer
  wants user to create new ones and edit them

  Scenario: List materials
    Given I am not logged in
    When I go to the materials page
    Then I should be on the materials page
    And I should see "lamp"
      
  Scenario: Try to register new material without login
    Given I am not logged in
    When I go to the new material page
    Then I should see "Need Login"




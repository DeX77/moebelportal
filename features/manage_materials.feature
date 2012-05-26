Feature: Manage materials
  In order to use different materials
  the developer
  wants user to create new ones and edit them
  
  Scenario: Try to register new material without login
    Given I am not logged in
    When I go to the new material page
    Then I should see "Need Login"




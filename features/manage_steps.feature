Feature: Manage steps
  In order to have different steps within the manual
  the developer
  wants user to create new ones,delete and edit them
  
  Scenario: Try to register new step without login
    Given I am not logged in
    When I go to the new step page
    Then I should see "Need Login"

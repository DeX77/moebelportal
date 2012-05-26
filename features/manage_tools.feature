Feature: Manage tools
  In order to provide different tools
  the developer
  wants user to create new ones and edit them
  
  Scenario: Try to register new tool without login
    Given I am not logged in
    When I go to the new tool page
    Then I should see "Need Login"

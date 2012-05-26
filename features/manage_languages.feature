Feature: Manage languages
  In order to provide different languages
  the developer
  wants user to create new ones and edit them
  
  Scenario: Try to register new language without login
    Given I am not logged in
    When I go to the new language page
    Then I should see "Need Login"



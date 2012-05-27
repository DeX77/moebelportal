Feature: Manage languages
  In order to provide different languages
  the developer
  wants user to create new ones and edit them

  Scenario: List languages
    Given I am not logged in
    When I go to the languages page
    Then I should be on the languages page
    And I should see "de"
    And I should see "en"
      
  Scenario: Try to register new language without login
    Given I am not logged in
    When I go to the new language page
    Then I should see "Need Login"



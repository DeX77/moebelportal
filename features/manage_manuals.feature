Feature: Manage manuals
  In order to create, edit and delete manuals
  the developer
  wants user to create new ones,edit them and delete his own
  
  Scenario: Try to add a new manual without login
    Given I am not logged in
    When I go to the new manual page
    Then I should see "Need Login"



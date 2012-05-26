Feature: Manage users
  In order to have usermanagement
  the developer
  wants admins to be able to add, delete or edit users
  
  Scenario: Try to register a new user without login
    Given I am not logged in
    When I go to the new user page
    Then I should see "Need Login"



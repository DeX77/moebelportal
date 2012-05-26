Feature: Manage usergroups
  In order to assing users to usergroups
  the developer
  wants admins to create usergroups and asign or resign users
  from them
  
  Scenario: Try to add a new usergroup without login
    Given I am not logged in
    When I go to the new usergroup page
    Then I should see "Need Login"
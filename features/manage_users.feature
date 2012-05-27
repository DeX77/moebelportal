Feature: Manage users
  In order to have usermanagement
  the developer
  wants admins to be able to add, delete or edit users
  
  Scenario: Try to register a new user without login
    Given I am not logged in
    When I go to the new user page
    Then I should see "Need Login"

  Scenario: Try login with wrong credentials
    Given I am not logged in
    When I go to the login page
    And I fill in "login" with "dex"
    And I fill in "pwd_" with "thisiswrong"
    And I press "Login"
    Then I should see "Poeser Pursche!!"
    And I should not see "Logged in"
    And I should not see "Logout"
    
  Scenario: Try login with correct credentials
    Given I am not logged in
    When I go to the login page
    And I fill in "login" with "dex"
    And I fill in "pwd_" with "dex"
    And I press "Login"
    Then I should not see "Poeser Pursche!!"
    But I should see "Logged in"
    And I should see "Logout"    

  Scenario: Logout
    Given I am logged in as "dex" with password "dex"
    When I go to the logout page    
    Then I should not see "Logged in"
    And I should not see "Logout"
    But I should see "Login"
    

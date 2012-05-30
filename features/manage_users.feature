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

  Scenario: Show non existing user
      Given I am not logged in
      When I go to a non existing user page
      Then I should be on the users page

  Scenario: Show an existing user
      Given I am not logged in
      When I go to the page of user named "dex"
      And I should see "dex"
      And I should see "of group"
      And I should see "reporters"
      
  Scenario: Try to edit an user without login
      Given I am not logged in
      When I go to the users page
      And I follow "Edit dex"
      Then I should be on the homepage
      And I should see "Need Login"
      
  Scenario: Try to edit an user while loged in
      Given I am logged in as "dex" with password "dex"
      When I go to the users page
      And I follow "Edit dex"
      Then I should be on the edit page of user "dex"
      And I should not see "Need Login"      
          
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

  Scenario: Add a user to a usergroup
    Given I am not logged in
    When I go to the page of user named "dex"    
    And I follow "Add dex to usergroup"
    And I select "reporters" from "group_id"
    And I press "Speichern"
    Then I should see "reporters"
    
    

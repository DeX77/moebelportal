Feature: Manage usergroups
  In order to assing users to usergroups
  the developer
  wants admins to create usergroups and asign or resign users
  from them

 Scenario: List usergroups
    Given I am not logged in
    When I go to the usergroups page
    Then I should be on the usergroups page
    And I should see "reporters"
  
  Scenario: Try to add a new usergroup without login
    Given I am not logged in
    When I go to the new usergroup page
    Then I should see "Need Login"
    
  Scenario: Try to add a new usergroup with correct login
    Given I am logged in as "dex" with password "dex"
    Given there is no usergroup named "Nerds"
    When I go to the new usergroup page
    Then I should not see "Need Login"
    When I fill in the following:
      | ID            | 0815                                                                                     |
      | Name          | Nerds                                                                                    |
      | Image Link    | http://3.bp.blogspot.com/-CWqKvWVIbuU/T5CYzgRRDYI/AAAAAAAAKGQ/RNlQrWfcIMI/s1600/moss.jpg |
      | desc_   | Fire, exclamation mark, fire                                                                   |
    And I press "Speichern"
    Then I should be on the page of usergroup named "Nerds"
   

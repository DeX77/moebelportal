Feature: Manage tools
  In order to provide different tools
  the developer
  wants user to create new ones and edit them

 Scenario: List tools
    Given I am not logged in
    When I go to the tools page
    Then I should be on the tools page
    And I should see "Schraubenschluessel"

  Scenario: Show non existing tool
      Given I am not logged in
      When I go to a non existing tool page
      Then I should be on the tools page

  Scenario: Show an existing tool
      Given I am not logged in
      When I go to the page of tool named "spanner"
      Then I should see "spanner"
      And I should see "needs tools"
      And I should see "fix centerline at lamp foot"
      And I should see "Create full lamp foot"
      And I should see "construct lamp foot"        
      
  Scenario: Try to register new tool without login
    Given I am not logged in
    When I go to the new tool page
    Then I should see "Need Login"

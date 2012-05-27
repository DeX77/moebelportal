Feature: Manage steps
  In order to have different steps within the manual
  the developer
  wants user to create new ones,delete and edit them

  Scenario: List steps
    Given I am not logged in
    When I go to the steps page
    Then I should be on the steps page
    And I should see "turn bulb in the centerline"
      
  Scenario: Try to register new step without login
    Given I am not logged in
    When I go to the new step page
    Then I should see "Need Login"

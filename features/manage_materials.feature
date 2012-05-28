Feature: Manage materials
  In order to use different materials
  the developer
  wants user to create new ones and edit them

  Scenario: List materials
    Given I am not logged in
    When I go to the materials page
    Then I should be on the materials page
    And I should see "lamp"

  Scenario: Show non existing material
      Given I am not logged in
      When I go to a non existing material page
      Then I should be on the materials page
      
  Scenario: Show an existing material
      Given I am not logged in
      When I go to the page of material named "lamp"
      Then I should see "lamp"
      And I should see "construction:"
      And I should see "put lamp cover at lamp body"
      And I should see "Finishing"
            
  Scenario: Try to register new material without login
    Given I am not logged in
    When I go to the new material page
    Then I should see "Need Login"




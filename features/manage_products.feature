Feature: Manage products
  In order to have different producs
  the developer
  wants user to create new ones and edit them
  
  Scenario: Try to add a new product without login
    Given I am not logged in
    When I go to the new product page
    Then I should see "Need Login"




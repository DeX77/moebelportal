Feature: Manage products
  In order to have different products
  the developer
  wants user to create new ones and edit them

  Scenario: List products
    Given I am not logged in
    When I go to the products page
    Then I should be on the products page
    And I should see "Textur"
      
  Scenario: Try to add a new product without login
    Given I am not logged in
    When I go to the new product page
    Then I should see "Need Login"

  Scenario: Try to add a new product with correct login
    Given I am logged in as "dex" with password "dex"
    Given there is no product named "Torquemada"
    When I go to the new product page
    Then I should not see "Need Login"
    When I fill in the following:
      | ID            | 4711                                                                                     |
      | Name          | Torquemada                                                                               |
      | Image Link    | http://www.theregister.co.uk/2005/04/01/torquemada.jpg                                   |
      | desc_         | At last, a chair with a point!                                                           |
    And I press "Speichern"
    Then I should be on the page of product named "Torquemada"
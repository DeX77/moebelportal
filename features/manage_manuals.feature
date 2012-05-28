Feature: Manage manuals
  In order to create, edit and delete manuals
  the developer
  wants user to create new ones,edit them and delete his own

  Scenario: List manuals
    Given I am not logged in
    When I go to the manuals page
    Then I should be on the manuals page
    And I should see "Textur manual"
    
  Scenario: List manuals
    Given I am not logged in
    When I go to the page of manual named "Textur manual"
    Then I should see "manual of"
    And I should see "Textur"    
    And I should see "set of step"  
    And I should see "Step 1: Create full lamp foot"        
    And I should see "Step 3: Construct full lamp body"        
    And I should see "Step 4: Finishing"        
    And I should see "Step 2: Create formed nappe"
    
  Scenario: Show non existing manual
      Given I am not logged in
      When I go to a non existing manual page
      Then I should be on the manuals page        
      
  Scenario: Try to add a new manual without login
    Given I am not logged in
    When I go to the new manual page
    Then I should see "Need Login"
    
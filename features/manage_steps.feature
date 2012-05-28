Feature: Manage steps
  In order to have different steps within the manual
  the developer
  wants user to create new ones,delete and edit them

  Scenario: List steps
    Given I am not logged in
    When I go to the steps page
    Then I should be on the steps page
    And I should see "turn bulb in the centerline"
    
  Scenario: Show step with step controller    
    Given I am not logged in
    When I go to the page of step named "turn bulb in the centerline"
    And I should see "do before"   
    And I should see "do after"        
    And I should see "parts of steps"  
    And I should see "conatins"  
    And I should see "Step 1: Create full lamp foot"        
    And I should see "material of step"  
    And I should see "electric bulb"        
    And I should see "centerline with electric bulb"        
    And I should see "is needed at"  
    And I should see "result of"

  Scenario: Show non existing step
      Given I am not logged in
      When I go to a non existing step page
      Then I should be on the steps page
          
  Scenario: Try to register new step without login
    Given I am not logged in
    When I go to the new step page
    Then I should see "Need Login"

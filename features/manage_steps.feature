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
    
  Scenario: Try to register a new step while loged in
    Given I am logged in as "dex" with password "dex"
    When I go to the new step page
    Then I should not see "Need Login"
    But I should see "Neuer Step"
    When I fill in the following:
      | ID            | 9991                                                                                     			  |
      | Name          | Turn me on                                                                               			  |
      | Image Link    | http://rlv.zcache.com/straight_girls_turn_me_on_poster-ra2e8de0f4124496792e4dea121b97be5_auhm_400.jpg |
      | desc_         | Uuuuh baby						                                                           			  | 
   And I press "Speichern"
   Then I should be on the page of step named "Turn me on"
   
  Scenario: Try to add another step before this
    Given I am logged in as "dex" with password "dex"   
    When I go to the page of step named "construct lamp foot"
    And I follow "Add step before construct lamp foot"
    And I select "Step 1: Create full lamp foot" from "step_id"
    And I press "Speichern"
    Then I should see "Step 1: Create full lamp foot"
    
  Scenario: Try to add another step after this
    Given I am logged in as "dex" with password "dex"   
    When I go to the page of step named "construct lamp foot"
    And I follow "Add step after construct lamp foot"
    And I select "fix centerline at lamp foot" from "step_id"
    And I press "Speichern"
    Then I should see "fix centerline at lamp foot"
  
  #Scenario: Try to add containing step to this
  #  Given I am logged in as "dex" with password "dex"     
  #  When I go to the page of step named "construct lamp foot"
  #  And I follow "Add containing step to construct lamp foot"
  #  And I select "Step 4: Finishing" from "step_id"
  #  And I press "Speichern"
  #  Then I should see "Step 4: Finishing"
    
  Scenario: Try to add a parent step to this
    Given I am logged in as "dex" with password "dex"     
    When I go to the page of step named "construct lamp foot"
    And I follow "Add parent step to construct lamp foot"
    And I select "Step 1: Create full lamp foot" from "step_id"
    And I press "Speichern"
    Then I should see "Step 1: Create full lamp foot"
    
  Scenario: Try to add a material step to this
    Given I am logged in as "dex" with password "dex"     
    When I go to the page of step named "construct lamp foot"
    And I follow "Add material to construct lamp foot"
    And I select "bottom plastic ring" from "material_id"
    And I press "Speichern"
    Then I should see "bottom plastic ring"

  Scenario: Try to add a tool step to this
    Given I am logged in as "dex" with password "dex"     
    When I go to the page of step named "construct lamp foot"
    And I follow "Add tool to construct lamp foot"
    And I select "Schraubenschluessel" from "tool_id"
    And I press "Speichern"
    Then I should see "Schraubenschluessel"

  Scenario: Try to add a result material to this
    Given I am logged in as "dex" with password "dex"     
    When I go to the page of step named "construct lamp foot"
    And I follow "Add result to construct lamp foot"
    And I select "lamp foot" from "material_id"
    And I press "Speichern"
    Then I should see "lamp foot"
       
    
        
   
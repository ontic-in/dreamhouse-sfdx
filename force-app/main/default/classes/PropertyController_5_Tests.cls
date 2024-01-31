
@isTest
private class PropertyController_5_Tests {

    @testSetup
    static void makeTestData() {
        // Create test properties
        List<Property__c> testProperties = new List<Property__c>();
        testProperties.add(new Property__c(
            Name = 'At Risk Property 1',
            Predicted_Days_On_Market__c = 31
        ));
        testProperties.add(new Property__c(
            Name = 'Not At Risk Property',
            Predicted_Days_On_Market__c = 20
        ));
        // Insert test properties
        insert testProperties;
    }
  
    @isTest
    static void testGetAtRiskPropertiesWithAtRiskProperties() {
        // Arrange
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
      
        // Act
        List<Property__c> result = PropertyController.getAtRiskProperties();
      
        // Assert
        System.assertEquals(1, result.size(), 'There should be 1 at-risk property returned');
        System.assertEquals('At Risk Property 1', result[0].Name, 'The name of the at-risk property should match');
    }
  
    @isTest
    static void testGetAtRiskPropertiesWithNoAtRiskProperties() {
        // Arrange
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        // Update the test data to manipulate the scenario
        List<Property__c> testProperties = [SELECT Id, Name, Predicted_Days_On_Market__c FROM Property__c];
        for(Property__c prop : testProperties) {
            prop.Predicted_Days_On_Market__c = 20; // Set below the at-risk threshold
        }
        update testProperties;
      
        // Act
        List<Property__c> result = PropertyController.getAtRiskProperties();
      
        // Assert
        System.assertEquals(0, result.size(), 'There should be no at-risk properties returned');
    }
}

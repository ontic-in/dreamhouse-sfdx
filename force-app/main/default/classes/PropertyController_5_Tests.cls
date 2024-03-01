
@isTest
private class PropertyController_5_Tests {

    @testSetup
    static void setupTestData() {
        // Create test data for Property__c with different Predicted_Days_On_Market__c values
        List<Property__c> properties = new List<Property__c>();
        properties.add(new Property__c(Name = 'Test Property 1', Predicted_Days_On_Market__c = 31));
        properties.add(new Property__c(Name = 'Test Property 2', Predicted_Days_On_Market__c = 10));
        insert properties;
    }

    @isTest
    static void testGetAtRiskProperties_HasAtRiskProperties() {
        // Execute the method to test
        Test.startTest();
        Property__c[] atRiskProperties = PropertyController.getAtRiskProperties();
        Test.stopTest();

        // There should be exactly one Property__c record with Predicted_Days_On_Market__c > 30
        System.assertEquals(1, atRiskProperties.size(), 'There should be one at-risk property.');
        System.assertEquals('Test Property 1', atRiskProperties[0].Name, 'The property name should match.');
    }

    @isTest
    static void testGetAtRiskProperties_NoAtRiskProperties() {
        // Change all properties to not be at-risk
        List<Property__c> propertiesToUpdate = [SELECT Id, Predicted_Days_On_Market__c FROM Property__c WHERE Predicted_Days_On_Market__c > 30];
        for (Property__c prop : propertiesToUpdate) {
            prop.Predicted_Days_On_Market__c = 10;
        }
        update propertiesToUpdate;

        // Execute the method to test
        Test.startTest();
        Property__c[] atRiskProperties = PropertyController.getAtRiskProperties();
        Test.stopTest();

        // There should be no at-risk properties
        System.assertEquals(0, atRiskProperties.size(), 'There should be no at-risk properties.');
    }
}

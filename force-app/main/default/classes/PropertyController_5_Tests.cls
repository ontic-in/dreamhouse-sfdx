
@isTest
private class PropertyController_5_Tests {

    @testSetup
    static void makeTestData() {
        // Insert some properties
        List<Property__c> properties = new List<Property__c>{
            new Property__c(Name = 'Property 1', Predicted_Days_On_Market__c = 35),
            new Property__c(Name = 'Property 2', Predicted_Days_On_Market__c = 40),
            new Property__c(Name = 'Property 3', Predicted_Days_On_Market__c = 10) // This one should not be "at risk"
        };
        insert properties;
    }

    @isTest
    static void testGetAtRiskPropertiesWithResults() {
        // Bypass triggers if they exist for the Property__c object
        // TriggerHandler.bypass('PropertyTriggerHandler');

        // Run the method
        List<Property__c> atRiskProperties = PropertyController.getAtRiskProperties();

        // Assert that the size is correct (2 at risk properties should be found)
        System.assertEquals(2, atRiskProperties.size(), 'There should be two at risk properties');

        // Assert that all properties have Predicted_Days_On_Market__c more than 30
        for (Property__c property : atRiskProperties) {
            System.assertTrue(property.Predicted_Days_On_Market__c > 30, 'The property should be at risk');
        }
    }

    @isTest
    static void testGetAtRiskPropertiesWithoutResults() {
        // Bypass triggers if they exist for the Property__c object
        // TriggerHandler.bypass('PropertyTriggerHandler');

        // Run the method
        List<Property__c> atRiskProperties = PropertyController.getAtRiskProperties();

        // Assert that no properties are returned
        System.assertEquals(0, atRiskProperties.size(), 'There should be no at risk properties');
    }
}

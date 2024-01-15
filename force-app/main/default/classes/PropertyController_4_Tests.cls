
@isTest
private class PropertyController_4_Tests {

    // Test setup method to create test data
    @testSetup
    static void setup() {
        // Bypassing the triggers for the test context
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Creating test data for Properties
        List<Property__c> testProperties = new List<Property__c>();
        Date today = Date.today();
        
        // Property with a listed date and no agreement should be fetched
        testProperties.add(new Property__c(
            Date_Listed__c=today, 
            Date_Agreement__c=null
        ));
        
        // Property with a listed date and agreement within the last 90 days should also be fetched
        testProperties.add(new Property__c(
            Date_Listed__c=today, 
            Date_Agreement__c=today.addDays(-85)
        ));
        
        // Insert the test properties into the database
        insert testProperties;
    }

    // Test method to verify that the getAvailableProperties method returns the correct records
    @isTest
    static void testHappyPath() {
        Test.startTest();
        List<Property__c> availableProperties = PropertyController.getAvailableProperties();
        Test.stopTest();

        // Assertions
        System.assertEquals(2, availableProperties.size(), 'Should return the correct number of available properties.');
        for(Property__c prop : availableProperties) {
            System.assertNotEquals(null, prop.Date_Listed__c, 'Date Listed should not be null.');
        }
    }

    // Test method to verify that the getAvailableProperties method returns an empty list when no records meet the criteria
    @isTest
    static void testSadPath() {
        // Delete all properties to ensure the sad path is tested
        delete [SELECT Id FROM Property__c];

        Test.startTest();
        List<Property__c> emptyPropertiesList = PropertyController.getAvailableProperties();
        Test.stopTest();

        // Assertions
        System.assertTrue(emptyPropertiesList.isEmpty(), 'Should return an empty list of available properties.');
    }
}

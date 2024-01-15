
@isTest
private class PropertyController_6_Tests {

    @testSetup
    static void setup() {
        // Create test properties
        List<Property__c> properties = new List<Property__c>();
        for (Integer i = 0; i < 10; i++) {
            properties.add(new Property__c(
                Name = 'Test Property ' + i, // Ensure 'Name' is the correct field API name
                Price__c = 500000 + (i * 10000) // Ensure 'Price__c' is the correct field API name
            ));
        }
        insert properties;
    }

    @isTest
    static void testGetComparablePropertiesHappyPath() {
        // Assume the setup method has created properties and get one propertyId
        Property__c prop = [SELECT Id FROM Property__c LIMIT 1];
        Id propertyId = prop.Id;

        // Bypass the trigger handlers for the test context
        // Update these lines if the trigger handlers are different for your org
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Perform the test
        Test.startTest();
        List<Property__c> comps = PropertyController.getComparableProperties(propertyId);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, comps, 'Comparables should not be null');
        System.assertTrue(comps.size() > 0, 'There should be at least one comparable property');
    }

    @isTest
    static void testGetComparablePropertiesSadPath() {
        // Use a price that is too high to have comparables
        Property__c prop = new Property__c(
            Name = 'Test Property High Price', // Ensure 'Name' is the correct field API name
            Price__c = 10000000 // Ensure 'Price__c' is the correct field API name
        );
        insert prop;

        // Bypass the trigger handlers for the test context
        // Update these lines if the trigger handlers are different for your org
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Perform the test
        Test.startTest();
        List<Property__c> comps = PropertyController.getComparableProperties(prop.Id);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, comps, 'Comparables should not be null');
        System.assertEquals(0, comps.size(), 'There should be no comparable properties');
    }

    @isTest
    static void testGetComparablePropertiesExceptionalScenario() {
        // Use an invalid propertyId
        Id propertyId = 'a01InvalidIDForTesting';

        // Bypass the trigger handlers for the test context
        // Update these lines if the trigger handlers are different for your org
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Exception caughtException;

        // Perform the test
        Test.startTest();
        try {
            List<Property__c> comps = PropertyController.getComparableProperties(propertyId);
        } catch (Exception e) {
            caughtException = e;
        }
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, caughtException, 'An exception should have been thrown for an invalid ID');
    }
}

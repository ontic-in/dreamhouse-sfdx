
@isTest
private class PropertyController_4_Tests {

    @testSetup
    static void setup() {
        // Mock properties data for testing
        List<Property__c> testProperties = new List<Property__c>();
        
        // Create Property that is listed and without agreement
        testProperties.add(new Property__c(
            Date_Listed__c = System.today(),
            Date_Agreement__c = null
        ));
        
        // Create Property that is listed and the agreement is within 90 days
        testProperties.add(new Property__c(
            Date_Listed__c = System.today(),
            Date_Agreement__c = System.today().addDays(-85)
        ));
        
        // Insert test data
        insert testProperties;
    }

    @isTest
    static void shouldReturnAvailableProperties() {
        // Bypass trigger handlers as per project specific details
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Perform test
        Test.startTest();
        Property__c[] availableProperties = PropertyController.getAvailableProperties();
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, availableProperties, 'The result should not be null.');
        System.assertEquals(2, availableProperties.size(), 'There should be 2 available properties returned.');
    }

    @isTest
    static void shouldReturnEmptyListIfNoAvailableProperties() {
        // Bypass trigger handlers as per project specific details
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Clear out the test data from the `@testSetup` method to simulate having no available properties.
        delete [SELECT Id FROM Property__c];
        
        // Perform test
        Test.startTest();
        Property__c[] availableProperties = PropertyController.getAvailableProperties();
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, availableProperties, 'The result should not be null.');
        System.assertEquals(0, availableProperties.size(), 'There should be no available properties returned.');
    }
}

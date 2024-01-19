
@isTest
private class PropertyController_1_Tests {
    @testSetup
    static void setup() {
        // Create test data
        List<Property__c> properties = new List<Property__c>();
        // Assuming that Property__c has fields like address__c, city__c, etc.
        properties.add(new Property__c(
            title__c='Test Property 1',
            city__c='TestCity',
            tags__c='TestTag',
            price__c=500000,
            beds__c=3,
            baths__c=2
        ));
        // Add more property data if needed
        insert properties;
        
        // Bypass the trigger handlers mentioned in the project details
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    @isTest
    static void testGetPropertyList_HappyPath() {
        Test.startTest();
        
        // Perform test
        Property__c[] properties = PropertyController.getPropertyList('Test', 400000, 600000, 2, 1, 'Test');
        
        // Assertions
        System.assertNotEquals(null, properties, 'The returned list should not be null.');
        System.assertEquals(1, properties.size(), 'There should be one matching property.');
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetPropertyList_NoResults() {
        Test.startTest();
        
        // Perform test
        Property__c[] properties = PropertyController.getPropertyList('NonExistent', 800000, 1200000, 5, 4, 'NonExistent');
        
        // Assertions
        System.assertNotEquals(null, properties, 'The returned list should not be null.');
        System.assertEquals(0, properties.size(), 'There should be no matching properties.');
        
        Test.stopTest();
    }
    
    // Exceptional scenarios depend on the implementation of the calling code.
    // Since Apex does not throw exceptions for invalid primitive types, there isn't a test here for invalid inputs.
}


@isTest
private class PropertyController_1_Tests {
    
    @testSetup
    static void setup() {
        // Bypass Account related triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Create test properties
        List<Property__c> testProperties = new List<Property__c>();
        for(Integer i = 0; i < 5; i++) {
            Property__c property = new Property__c(
                Title__c = 'Test Property ' + i,
                City__c = 'Test City',
                Tags__c = 'Test,Sample',
                Price__c = 500000 + i * 100000, // Price ranges from 500,000 to 900,000
                Beds__c = i + 1, // Bedrooms from 1 to 5
                Baths__c = i + 1 // Bathrooms from 1 to 5
                // Ensure other required fields for the Property__c object are included
            );
            // Add any other required fields for the Property__c object
            testProperties.add(property);
        }
        insert testProperties;
    }
    
    @isTest
    static void testGetPropertyListHappyPath() {
        // Test for happy path with valid searchKey and visualSearchKey
        Test.startTest();
        Property__c[] retrievedProperties = PropertyController.getPropertyList(
            'Test', 500000, 900000, 2, 2, 'Sample'
        );
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(0, retrievedProperties.size(), 'Should return properties.');
        for(Property__c prop : retrievedProperties) {
            System.assertTrue(prop.Price__c >= 500000 && prop.Price__c <= 900000, 'Property should be within price range.');
        }
    }
    
    @isTest
    static void testGetPropertyListNoResults() {
        // Test for sad path with search criteria that does not match any records
        Test.startTest();
        Property__c[] retrievedProperties = PropertyController.getPropertyList(
            'Nonexistent', 950000, 1000000, 5, 5, 'Nonexistent'
        );
        Test.stopTest();
        
        // Assertions
        System.assertEquals(0, retrievedProperties.size(), 'Should not return any properties.');
    }
    
    // Additional test methods for other scenarios can be added here...
}

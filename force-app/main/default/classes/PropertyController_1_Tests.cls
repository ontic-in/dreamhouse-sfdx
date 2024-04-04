
@isTest
private class PropertyController_1_Tests {

    private static void createTestProperties() {
        List<Property__c> properties = new List<Property__c>();
        // Create properties with varying attributes to match different query criteria
        properties.add(new Property__c(
            title__c = 'Seaside Villa',
            city__c = 'Oceanview',
            state__c = 'CA',
            price__c = 800000,
            beds__c = 3,
            baths__c = 2,
            tags__c = 'luxury;seaside;villa'
        ));
        // Add more properties as needed...
        
        // Insert test data
        insert properties;
    }

    @isTest
    static void testGetPropertiesHappyPath() {
        // Create test data
        createTestProperties();

        // Test the method with parameters that should return results
        Test.startTest();
        Property__c[] properties = PropertyController.getPropertyList('Villa', 500000, 1000000, 2, 1, 'seaside');
        Test.stopTest();

        // Verify that properties are returned
        System.assertNotEquals(null, properties, 'The properties list should not be null.');
        System.assertEquals(1, properties.size(), 'Expected one property to be returned.');
    }

    @isTest
    static void testGetPropertiesSadPath() {
        // Create test data
        createTestProperties();

        // Test the method with parameters that should not return any results
        Test.startTest();
        Property__c[] properties = PropertyController.getPropertyList('Nonexistent', 500000, 1000000, 2, 1, 'seaside');
        Test.stopTest();

        // Verify that no properties are returned
        System.assertEquals(0, properties.size(), 'Expected no properties to be returned.');
    }

    @isTest
    static void testGetPropertiesExceptionalScenario() {
        // Create test data
        createTestProperties();

        // Test the method with null values which might cause query to fail
        Test.startTest();
        Property__c[] properties = PropertyController.getPropertyList(null, null, null, null, null, null);
        Test.stopTest();

        // Verify that the query does not cause an exception and returns an empty list
        System.assertEquals(0, properties.size(), 'Expected an empty list of properties.');
    }
}

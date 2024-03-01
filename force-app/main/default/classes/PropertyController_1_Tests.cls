
@isTest
private class PropertyController_1_Tests {

    @testSetup
    static void setup() {
        // Create test properties with necessary fields populated
        List<Property__c> properties = new List<Property__c>();
        properties.add(new Property__c(
            title__c = 'Test Property 1',
            city__c = 'TestCity',
            tags__c = 'TestTag',
            price__c = 500000,
            baths__c = 3,
            beds__c = 4,
            address__c = '123 Test Street',
            state__c = 'TestState',
            description__c = 'Test Description',
            thumbnail__c = 'Test Thumbnail',
            location__latitude__s = 90.0,
            location__longitude__s = 0.0
        ));
        
        // Insert test data
        insert properties;
    }

    @isTest
    static void testGetPropertyListWithAllParams() {
        // Call the method with all parameters set
        List<Property__c> result = PropertyController.getPropertyList('Test', 400000, 600000, 3, 2, 'Test');
        // Assert the result contains the expected number of properties
        System.assertEquals(1, result.size(), 'Should return one property matching the criteria.');
    }

    @isTest
    static void testGetPropertyListWithSomeNullParams() {
        // Call the method with some null parameters
        List<Property__c> result = PropertyController.getPropertyList(null, 0, null, 0, 0, null);
        // Assert that the result contains properties
        System.assertTrue(result.size() > 0, 'Should return properties even if some parameters are null.');
    }

    @isTest
    static void testGetPropertyListWithNoMatches() {
        // Call the method with parameters that will not match any property
        List<Property__c> result = PropertyController.getPropertyList('Nonexistent', 1000000, 2000000, 10, 10, 'Nonexistent');
        // Assert no properties are returned
        System.assertEquals(0, result.size(), 'Should return no properties as no matching criteria.');
    }

    @isTest
    static void testGetPropertyListWithContradictoryParams() {
        // Call the method with contradictory parameters
        List<Property__c> result = PropertyController.getPropertyList('Test', 600000, 400000, 3, 2, 'Test');
        // Assert no properties are returned due to contradictory price range
        System.assertEquals(0, result.size(), 'Should return no properties due to contradictory price range.');
    }
}

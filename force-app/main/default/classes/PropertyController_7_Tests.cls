
@isTest
private class PropertyController_7_Tests {

    @testSetup
    static void createTestData() {
        // Setup test data
        // As we are not provided with the definition of Property__c, we'll assume some basic fields for the object.
        List<Property__c> properties = new List<Property__c>();
        // We'll create a few properties with different bedrooms and prices
        properties.add(new Property__c(Beds__c = 3, Price__c = 500000));
        properties.add(new Property__c(Beds__c = 4, Price__c = 650000));
        properties.add(new Property__c(Beds__c = 3, Price__c = 550000));
        insert properties;
    }

    @isTest
    static void shouldReturnPropertiesByBedrooms() {
        Test.startTest();
        List<Property__c> results = PropertyController.getSimilarProperties(null, 3, 0, 'Bedrooms');
        Test.stopTest();

        // Assertions
        System.assertEquals(2, results.size(), 'Should return correct number of properties with matching bedrooms.');
        for (Property__c property : results) {
            System.assertEquals(3, property.Beds__c, 'Property should have 3 bedrooms.');
        }
    }

    @isTest
    static void shouldReturnPropertiesByPriceRange() {
        Test.startTest();
        List<Property__c> results = PropertyController.getSimilarProperties(null, 0, 600000, '');
        Test.stopTest();

        // Assertions
        System.assert(results.size() > 0, 'Should return properties within price range.');
        for (Property__c property : results) {
            System.assert(property.Price__c >= 500000 && property.Price__c <= 700000, 'Price should be within range.');
        }
    }

    @isTest
    static void shouldReturnEmptyListWhenNoPropertiesMatch() {
        Test.startTest();
        List<Property__c> results = PropertyController.getSimilarProperties(null, 10, 0, 'Bedrooms');
        Test.stopTest();

        // Assertions
        System.assertEquals(0, results.size(), 'Should return an empty list for non-matching criteria.');
    }

    @isTest
    static void shouldHandleInvalidSearchCriteria() {
        Test.startTest();
        List<Property__c> results = PropertyController.getSimilarProperties(null, 0, 0, 'InvalidCriteria');
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, results, 'Should not return null for invalid search criteria.');
        System.assertEquals(0, results.size(), 'Should return an empty list for invalid criteria.');
    }
}

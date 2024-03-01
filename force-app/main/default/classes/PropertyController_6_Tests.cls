
@isTest
private class PropertyController_6_Tests {

    @testSetup
    static void setupTestData() {
        // Create test properties
        List<Property__c> properties = new List<Property__c>();
        for (Integer i = 0; i < 10; i++) {
            properties.add(new Property__c(
                Name = 'Test Property ' + i,
                Price__c = 500000 + (i * 10000) // Different price for each property
            ));
        }
        insert properties;
    }

    @isTest
    static void shouldReturnComparableProperties() {
        // Query one of the test properties to use as input
        Property__c baseProperty = [SELECT Id, Price__c FROM Property__c LIMIT 1];

        // Perform test
        Test.startTest();
        List<Property__c> comparableProperties = PropertyController.getComparableProperties(baseProperty.Id);
        Test.stopTest();

        // Assert that the returned list is not null and contains properties
        System.assertNotEquals(null, comparableProperties, 'The result should not be null.');
        System.assertTrue(comparableProperties.size() > 0, 'There should be comparable properties.');
    }

    @isTest
    static void shouldReturnEmptyListWhenNoComparableProperties() {
        // Create a property with a unique price that won't have comparables
        Property__c uniqueProperty = new Property__c(
            Name = 'Unique Property',
            Price__c = 9999999 // A unique high price to ensure no comparables
        );
        insert uniqueProperty;

        // Perform test
        Test.startTest();
        List<Property__c> comparableProperties = PropertyController.getComparableProperties(uniqueProperty.Id);
        Test.stopTest();

        // Assert that the returned list is empty
        System.assertEquals(0, comparableProperties.size(), 'There should be no comparable properties.');
    }

    @isTest
    static void shouldHandleInvalidPropertyId() {
        // Prepare a dummy ID to simulate an invalid ID
        String invalidPropertyIdString = 'a01XXXXXXX'; // Invalid ID format
        Id invalidPropertyId = Id.valueOf(invalidPropertyIdString);

        // Perform test
        Test.startTest();
        List<Property__c> comparableProperties = PropertyController.getComparableProperties(invalidPropertyId);
        Test.stopTest();

        // Assert that the returned list is empty, indicating that no comparables were found for an invalid ID
        System.assertEquals(0, comparableProperties.size(), 'The result should be an empty list for an invalid property ID.');
    }
}

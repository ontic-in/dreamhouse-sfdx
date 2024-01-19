
@isTest
private class PropertyController_6_Tests {

    @testSetup
    static void setupTestData() {
        List<Property__c> properties = new List<Property__c>();

        // Insert a target property
        Property__c targetProperty = new Property__c(
            Price__c = 500000
            // ... other required fields
        );
        properties.add(targetProperty);

        // Insert a comparable property within $100,000 range
        Property__c comparableProperty = new Property__c(
            Price__c = 450000
            // ... other required fields
        );
        properties.add(comparableProperty);

        // Insert a non-comparable property outside $100,000 range
        Property__c nonComparableProperty = new Property__c(
            Price__c = 200000
            // ... other required fields
        );
        properties.add(nonComparableProperty);

        insert properties;
    }

    @isTest
    static void testGetComparablePropertiesHappyPath() {
        Property__c targetProperty = [SELECT Id, Price__c FROM Property__c WHERE Price__c = 500000 LIMIT 1];

        Test.startTest();
        List<Property__c> comparables = PropertyController.getComparableProperties(targetProperty.Id);
        Test.stopTest();

        System.assertNotEquals(0, comparables.size(), 'There should be at least one comparable property.');
        System.assert(comparables[0].Price__c >= (targetProperty.Price__c - 100000)
            && comparables[0].Price__c <= (targetProperty.Price__c + 100000),
            'The price of the comparable property should be within the specified range.');
    }

    @isTest
    static void testGetComparablePropertiesWithNoMatches() {
        Property__c targetProperty = [SELECT Id, Price__c FROM Property__c WHERE Price__c = 200000 LIMIT 1];

        Test.startTest();
        List<Property__c> comparables = PropertyController.getComparableProperties(targetProperty.Id);
        Test.stopTest();

        System.assertEquals(0, comparables.size(), 'There should be no comparable properties.');
    }

    @isTest
    static void testGetComparablePropertiesNullId() {
        Exception expectedException;

        Test.startTest();
        try {
            List<Property__c> comparables = PropertyController.getComparableProperties(null);
        } catch (Exception e) {
            expectedException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, expectedException, 'An exception should have been thrown for a null ID.');
    }

    @isTest
    static void testGetComparablePropertiesInvalidId() {
        Exception expectedException;

        Test.startTest();
        try {
            List<Property__c> comparables = PropertyController.getComparableProperties('INVALID_ID');
        } catch (Exception e) {
            expectedException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, expectedException, 'An exception should have been thrown for an invalid ID.');
    }
}

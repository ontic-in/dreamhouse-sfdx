
@isTest
private class PropertyController_6_Tests {

    @testSetup
    static void setupTestData() {
        List<Property__c> testProperties = new List<Property__c>();
        for(Integer i = 0; i < 10; i++) {
            testProperties.add(new Property__c(
                Name = 'Property ' + i,
                Price__c = 500000 + (i * 10000) // Different prices to test comparability
            ));
        }
        insert testProperties;
    }

    @isTest
    static void testWithComparableProperties() {
        Property__c referenceProperty = [SELECT Id, Price__c FROM Property__c LIMIT 1];
        List<Property__c> comparableProperties = PropertyController.getComparableProperties(referenceProperty.Id);
        System.assertNotEquals(null, comparableProperties, 'The result should not be null.');
        System.assert(comparableProperties.size() > 0, 'There should be comparable properties.');
    }

    @isTest
    static void testWithoutComparableProperties() {
        Property__c uniqueProperty = new Property__c(Name = 'Unique Property', Price__c = 9999999);
        insert uniqueProperty;
        List<Property__c> comparableProperties = PropertyController.getComparableProperties(uniqueProperty.Id);
        System.assertNotEquals(null, comparableProperties, 'The result should not be null.');
        System.assertEquals(0, comparableProperties.size(), 'There should not be any comparable properties.');
    }

    @isTest
    static void testWithInvalidPropertyId() {
        Id invalidId = Id.valueOf('a0Q000000000001AAA');
        Exception caughtException = null;
        Test.startTest();
        try {
            List<Property__c> comparableProperties = PropertyController.getComparableProperties(invalidId);
        } catch (Exception e) {
            caughtException = e;
        }
        Test.stopTest();
        
        System.assertNotEquals(null, caughtException, 'An exception should have been thrown for an invalid Id.');
        System.assert(caughtException instanceof QueryException, 'The exception should be a QueryException.');
    }
}

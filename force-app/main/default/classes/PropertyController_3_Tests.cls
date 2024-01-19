
@isTest
private class PropertyController_3_Tests {

    @testSetup
    static void setup() {
        // Create test data
        Property__c testProperty = new Property__c(
            Name = 'Test Property',
            beds__c = 3,
            baths__c = 2,
            address__c = '123 Test St',
            city__c = 'Test City',
            state__c = 'TS',
            price__c = 500000
        );
        insert testProperty;
    }

    @isTest
    static void testFindByIdHappyPath() {
        // Retrieve the test property ID
        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];

        // Perform test
        Test.startTest();
        Property__c result = PropertyController.findById(testProperty.Id);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'The property should be found');
        System.assertEquals(testProperty.Id, result.Id, 'The property ID should match the test data');
    }

    @isTest
    static void testFindByIdSadPath() {
        // Generate a dummy ID that doesn't exist by incrementing a real ID
        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];
        Id dummyId = testProperty.Id;
        String dummyIdString = String.valueOf(dummyId);
        String incrementedIdString = dummyIdString.substring(0, dummyIdString.length() - 3) + '999';
        Id incrementedId = Id.valueOf(incrementedIdString);

        // Perform test
        Test.startTest();
        Property__c result = PropertyController.findById(incrementedId);
        Test.stopTest();

        // Assertions
        System.assertEquals(null, result, 'The property should not be found because it does not exist');
    }

    @isTest
    static void testFindByIdExceptionalScenario() {
        // Pass an invalid ID format
        String invalidId = '12345';
        Exception caughtException = null;

        try {
            // Perform test (expected to throw exception)
            Test.startTest();
            Property__c result = PropertyController.findById(invalidId);
            Test.stopTest();
        } catch (Exception e) {
            caughtException = e;
        }

        // Assertions
        System.assertNotEquals(null, caughtException, 'An exception should have been thrown due to invalid ID format');
        System.assert(caughtException instanceof System.QueryException, 'The thrown exception should be a QueryException');
    }
}

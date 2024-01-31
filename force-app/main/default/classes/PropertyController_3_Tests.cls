
@isTest
private class PropertyController_3_Tests {

    @testSetup
    static void makeTestData() {
        // Create test data for Property__c
        Property__c testProperty = new Property__c(
            // Set necessary fields for the Property__c object
            // ...
        );
        insert testProperty;
    }

    @isTest
    static void testFindByIdValidId() {
        // Retrieve the test data
        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];

        // Call the method with a valid ID
        Test.startTest();
        Property__c result = PropertyController.findById(testProperty.Id);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'The property should not be null.');
        System.assertEquals(testProperty.Id, result.Id, 'The ID of the property should match the test data ID.');
    }

    @isTest
    static void testFindByIdInvalidId() {
        // Generate a dummy ID that doesn't exist in the test data
        Id dummyId = 'a0Nxxxxxxxxxxxxxxx';

        // Call the method with an ID that doesn't correspond to any record
        Test.startTest();
        Property__c result = PropertyController.findById(dummyId);
        Test.stopTest();

        // Assertions
        System.assertEquals(null, result, 'The result should be null for an invalid ID.');
    }

    @isTest
    static void testFindByIdExceptionForInvalidIdFormat() {
        // Setup an invalid ID format
        Id invalidId = '12345';

        // We expect an exception to be thrown here, so we'll use try-catch to assert that
        Exception actualException;
        try {
            Test.startTest();
            Property__c result = PropertyController.findById(invalidId);
            Test.stopTest();
        } catch (Exception e) {
            actualException = e;
        }

        // Assertions
        System.assertNotEquals(null, actualException, 'A QueryException should be thrown for an invalid ID format.');
    }
}

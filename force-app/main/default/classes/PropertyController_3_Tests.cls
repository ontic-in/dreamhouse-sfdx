
@isTest
private class PropertyController_3_Tests {

    @testSetup
    static void setup() {
        // Create test data
        Property__c testProperty = new Property__c(
            Name = 'Test Property',
            Beds__c = 3,
            Baths__c = 2,
            Address__c = '123 Main St',
            City__c = 'Test City',
            State__c = 'TS',
            Assessed_Value__c = 500000,
            Price__c = 550000
        );
        insert testProperty;
    }

    @isTest
    static void testFindByIdValidId() {
        // Retrieve the id from the test data
        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];
        Id validId = testProperty.Id;

        // Test method with a valid Id
        Test.startTest();
        Property__c result = PropertyController.findById(validId);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'The property should not be null.');
        System.assertEquals(validId, result.Id, 'The property Id should match the test property Id.');
    }

    @isTest
    static void testFindByIdInvalidId() {
        // Generate a random Id which will not exist in the test context
        Id invalidId = Id.valueOf('a0Nxxxxxxxxxxxxxxx');

        // Test method with an invalid Id
        Test.startTest();
        Property__c result = PropertyController.findById(invalidId);
        Test.stopTest();

        // Assertions
        System.assertEquals(null, result, 'The property should be null for an invalid Id.');
    }

    @isTest
    static void testFindByIdNoRowsReturned() {
        // Id for a non-existent Property__c record
        Id nonExistentId = Id.valueOf('a0N0000000000000AAA');

        Test.startTest();
        Property__c result = PropertyController.findById(nonExistentId);
        Test.stopTest();

        // Assertions
        System.assertEquals(null, result, 'The property should be null when a non-existent Id is used.');
    }
}

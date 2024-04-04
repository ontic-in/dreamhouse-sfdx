
@isTest
private class PropertyController_3_Tests {

    // Happy Path Test: Ensures that a valid record is returned when a correct Id is provided.
    @isTest
    static void testFindByIdWithValidId() {
        // Arrange
        Property__c testProperty = new Property__c(
            // Required fields are set accordingly
        );
        insert testProperty;

        // Act
        Test.startTest();
        Property__c result = PropertyController.findById(testProperty.Id);
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals(testProperty.Id, result.Id, 'The returned property ID should match the requested ID.');
    }

    // Sad Path Test: Ensures that an exception is thrown when an Id that doesn't exist is used.
    @isTest
    static void testFindByIdWithInvalidId() {
        // Arrange
        Id fakeId = generateFakeId(Property__c.SObjectType);

        // Act and Assert
        Boolean caughtException = false;
        Test.startTest();
        try {
            Property__c result = PropertyController.findById(fakeId);
        } catch (System.QueryException e) {
            caughtException = true;
        }
        Test.stopTest();

        System.assert(caughtException, 'A QueryException should be thrown for a non-existent ID.');
    }

    // Exceptional Scenario Test: Ensures that an exception is thrown when null is passed as the Id.
    @isTest
    static void testFindByIdWithNullId() {
        // Act and Assert
        Boolean caughtException = false;
        Test.startTest();
        try {
            Property__c result = PropertyController.findById(null);
        } catch (System.QueryException e) {
            caughtException = true;
        }
        Test.stopTest();

        System.assert(caughtException, 'A QueryException should be thrown when the Id parameter is null.');
    }
    
    // Helper method to generate a fake Salesforce Id for a given SObjectType
    private static Id generateFakeId(Schema.SObjectType sObjType) {
        String objPrefix = sObjType.getDescribe().getKeyPrefix();
        String suffix = '0'.repeat(15 - objPrefix.length()); // 15-character Id suffix
        return Id.valueOf(objPrefix + suffix);
    }
}

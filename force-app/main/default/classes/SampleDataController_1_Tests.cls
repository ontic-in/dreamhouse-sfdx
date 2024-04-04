
@isTest
private class SampleDataController_1_Tests {

    // Test method to verify that importSampleData works correctly when the user has the necessary permissions
    @isTest
    static void testImportSampleDataWithPermissions() {
        // Set up mock data and permissions as needed for the test
        // Simulate the conditions where user has necessary CRUD permissions

        // Perform the test
        Test.startTest();
        SampleDataController.importSampleData();
        Test.stopTest();

        // Verify the results
        Integer botCommandCount = [SELECT COUNT() FROM Bot_Command__c];
        Integer propertyCount = [SELECT COUNT() FROM Property__c];
        
        System.assertNotEquals(0, botCommandCount, 'Bot_Command__c records should have been created.');
        System.assertNotEquals(0, propertyCount, 'Property__c records should have been created.');
    }
}

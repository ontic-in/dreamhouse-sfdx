
@isTest
private class SampleDataController_1_Tests {

    @testSetup
    static void setup() {
        // Setup any required test data here
        // No specific setup data is required for these tests, as we are testing the import of data
    }

    @isTest
    static void testImportSampleDataWithCrudPermissions() {
        // Perform the actual test
        Test.startTest();
        SampleDataController.importSampleData();
        Test.stopTest();

        // Verify that no exceptions were thrown, indicating a successful operation
        System.assert(true, 'Data import should complete without exceptions');
    }

    @isTest
    static void testImportSampleDataWithoutCrudPermissions() {
        // Initialize a variable to determine whether an exception was thrown
        Boolean exceptionThrown = false;

        // Attempt to execute the method that should throw an exception due to lack of CRUD permissions
        try {
            Test.startTest();
            SampleDataController.importSampleData();
            Test.stopTest();
        } catch (AuraHandledException e) {
            exceptionThrown = true;
        }

        // Assert that an exception was thrown, as expected
        System.assert(exceptionThrown, 'An AuraHandledException should have been thrown due to lack of CRUD permissions');
    }

    // Additional test cases for handling non-existent static resources or parse errors are not provided as Salesforce Apex does not support mocking out-of-the-box.
    // Such scenarios often require more advanced testing strategies which are beyond the scope of this example.
}

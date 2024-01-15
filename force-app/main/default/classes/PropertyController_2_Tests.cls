
@isTest
private class PropertyController_2_Tests {

    // Utilizing @testSetup to create test data
    @testSetup
    static void setup() {
        // Bypass triggers that would affect DML operations
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create a set of properties to use in tests
        // ... properties setup as before ...
        insert propertiesToInsert;
    }

    // Happy path test
    @isTest
    static void testGetPaginatedPropertyList() {
        Test.startTest();
        // Assuming PropertyListPage is a public class accessible from PropertyController
        PropertyController.PropertyListPage result = PropertyController.getPropertyListPage(
            'Test Property', 500000, 600000, 2, 1, 'Test', 5, 1
        );
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'Result should not be null.');
        System.assertTrue(result.properties.size() > 0, 'Properties list should not be empty.');
        System.assertEquals(1, result.pageNumber, 'Page number should be 1');
    }

    // Sad path test
    @isTest
    static void testGetEmptyPaginatedPropertyList() {
        Test.startTest();
        PropertyController.PropertyListPage result = PropertyController.getPropertyListPage(
            'Nonexistent', 1000000, 2000000, 10, 10, 'Nonexistent', 5, 1
        );
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'Result should not be null.');
        System.assertEquals(0, result.properties.size(), 'Properties list should be empty.');
        System.assertEquals(0, result.total, 'Total property count should be 0.');
    }

    // Test with edge values for page size and number
    @isTest
    static void testGetPaginatedPropertyListWithEdgeValues() {
        Test.startTest();
        PropertyController.PropertyListPage result = PropertyController.getPropertyListPage(
            'Test Property', 500000, 600000, 2, 1, 'Test', -1, 0
        );
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'Result should not be null.');
        // The following assertions are based on the assumption that the method handles invalid
        // values for pageSize and pageNumber by substituting default values.
        // If this is not the actual behavior, replace these with assertions that reflect the real behavior.
        System.assertTrue(result.pageSize > 0, 'Page size should be greater than 0.');
        System.assertTrue(result.pageNumber > 0, 'Page number should be greater than 0.');
    }
}

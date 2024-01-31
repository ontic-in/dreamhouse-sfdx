
@isTest
private class PropertyController_1_Tests {
    
    @testSetup
    static void setup() {
        // Assuming there's a similar naming convention for Property triggers
        TriggerHandler.bypass('PropertyTriggerHandler');
        
        // Create test properties that would be fetched in the test methods
        List<Property__c> testProperties = new List<Property__c>{
            // Add properties with different criteria to test against
            // Example:
            new Property__c(title__c='Test Property', city__c='Test City', price__c=200000, beds__c=3, baths__c=2, tags__c='Test Tag')
            // Add more properties as needed for various test cases
        };
        
        insert testProperties;
    }
    
    @isTest
    static void testHappyPath() {
        // Call getPropertyList with valid parameters that match test data
        Test.startTest();
        List<Property__c> properties = PropertyController.getPropertyList('Test', 150000, 250000, 2, 1, 'Test');
        Test.stopTest();
        
        // Assertions to check if expected properties are returned
        System.assertNotEquals(null, properties, 'The result should not be null.');
        System.assert(properties.size() > 0, 'Should return at least one property.');
    }
    
    @isTest
    static void testNoResults() {
        // Call getPropertyList with valid parameters but no matching properties
        Test.startTest();
        List<Property__c> properties = PropertyController.getPropertyList('nomatch', 100000, 500000, 2, 1, 'visual');
        Test.stopTest();
        
        // Assertions to check no properties are returned
        System.assertEquals(0, properties.size(), 'Should return no properties.');
    }
    
    @isTest
    static void testBoundaryConditions() {
        // Test the exact boundary conditions for the price filter
        Test.startTest();
        List<Property__c> properties = PropertyController.getPropertyList('Test', 200000, 200000, 3, 2, 'Test');
        Test.stopTest();
        
        // Assertions to check if property with boundary price is returned
        System.assertNotEquals(null, properties, 'The result should not be null.');
        System.assert(properties.size() == 1, 'Should return exactly one property with the boundary price.');
    }
    
    @isTest
    static void testNullInputs() {
        // Call getPropertyList with some null parameters
        Test.startTest();
        List<Property__c> properties = PropertyController.getPropertyList(null, null, null, null, null, null);
        Test.stopTest();
        
        // Assertions to check how method handles null inputs
        System.assertNotEquals(null, properties, 'The result should not be null.');
        System.assertEquals(0, properties.size(), 'Should return no properties when all inputs are null.');
    }
    
    @isTest
    static void testExceptionalScenario() {
        Boolean exceptionThrown = false;
        try {
            // Call getPropertyList with parameters that might cause exceptions
            Test.startTest();
            List<Property__c> properties = PropertyController.getPropertyList('search', 0, 2147483647, 2, 1, 'visual');
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
        }
        
        // Assert that an exception was thrown
        System.assert(exceptionThrown, 'An exception should have been thrown due to invalid input parameters.');
    }
}

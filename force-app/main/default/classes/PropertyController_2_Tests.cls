
@isTest
private class PropertyController_2_Tests {

    @testSetup
    static void setup() {
        // Create test data for Property__c
        List<Property__c> properties = new List<Property__c>();
        for (Integer i = 0; i < 10; i++) {
            properties.add(new Property__c(
                title__c = 'Test Property ' + i,
                price__c = 100000 + (10000 * i),
                beds__c = i % 5,
                baths__c = i % 3,
                address__c = '123 Fake St',
                city__c = 'Test City',
                state__c = 'Test State',
                tags__c = 'Test'
            ));
        }
        insert properties;
    }
    
    // Happy path test
    @isTest
    static void testGetPropertiesListPage_HappyPath() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Call the method with valid parameters
        PropertyController.PropertyListPage result = PropertyController.getPropertyListPage('Test', 100000, 200000, 1, 1, 'Test', 5, 1);
        
        // Assertions
        System.assertEquals(5, result.pageSize);
        System.assertEquals(1, result.pageNumber);
        System.assert(result.properties != null);
        System.assert(result.total > 0, 'Expected total to be greater than 0');
    }

    // Sad path test
    @isTest
    static void testGetPropertiesListPage_NoResults() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Query parameters that do not match any properties
        PropertyController.PropertyListPage result = PropertyController.getPropertyListPage('Nonexistent', 9999999, 9999999, 10, 10, 'Nonexistent', 5, 1);
        
        // Assertions - Expecting empty results but correct pagination details
        System.assertEquals(5, result.pageSize);
        System.assertEquals(1, result.pageNumber);
        System.assertEquals(0, result.total);
        System.assertEquals(0, result.properties.size(), 'Expected properties list to be empty');
    }
    
    // Exceptional scenario test
    @isTest
    static void testGetPropertiesListPage_InvalidInput() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Boolean exceptionThrown = false;
        try {
            PropertyController.getPropertyListPage('Test', 100000, 200000, 1, 1, 'Test', -1, 0);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assert(exceptionThrown, 'Expected an exception for invalid pageSize/pageNumber');
    }
    
    // Boundary cases test
    @isTest
    static void testGetPropertiesListPage_BoundaryCase() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Maximum page size and page number
        PropertyController.PropertyListPage resultMax = PropertyController.getPropertyListPage('Test', 100000, 200000, 1, 1, 'Test', Integer.MAX_VALUE, Integer.MAX_VALUE);
        
        // Assertions for boundary case
        System.assertEquals(Integer.MAX_VALUE, resultMax.pageSize);
        System.assertEquals(Integer.MAX_VALUE, resultMax.pageNumber);
        System.assert(resultMax.properties != null);
        
        // Minimum page size and page number
        PropertyController.PropertyListPage resultMin = PropertyController.getPropertyListPage('Test', 100000, 200000, 1, 1, 'Test', 1, 1);
        
        // Assertions for boundary case
        System.assertEquals(1, resultMin.pageSize);
        System.assertEquals(1, resultMin.pageNumber);
        System.assert(resultMin.properties.size() <= 1, 'Expected only one or zero properties on the minimum boundary case');
    }
}

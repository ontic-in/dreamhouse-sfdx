
@isTest
global with sharing class PropertyController_2_Tests {

    // Test Setup to create test data
    @testSetup
    static void setup() {
        // Create and insert test properties
        List<Property__c> testProperties = new List<Property__c>();
        for(Integer i = 0; i < 5; i++) {
            testProperties.add(new Property__c(
                title__c = 'Test Property ' + i,
                city__c = 'Test City',
                tags__c = 'Test Tags',
                price__c = 500000 + i * 10000, // Different prices
                beds__c = i, // Different number of bedrooms
                baths__c = i // Different number of bathrooms
            ));
        }
        insert testProperties;
    }
    
    // Happy Path Scenario Test: Check valid property page is returned
    @isTest
    static void testValidPropertyListPage() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Test.startTest();
        PropertyController.PropertyListPage result = PropertyController.getPropertyListPage(
            'Test',
            490000,
            600000,
            2,
            2,
            '',
            2,
            1
        );
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals(2, result.pageSize, 'Page size should be 2.');
        System.assertEquals(1, result.pageNumber, 'Page number should be 1.');
        System.assertNotEquals(null, result.properties, 'The properties list should not be null.');
        System.assertTrue(result.total > 0, 'The total number of properties should be greater than 0.');
        System.assertEquals(2, result.properties.size(), 'There should be 2 properties returned.');
    }
    
    // Sad Path Scenario Test: Check handling of no matching properties
    @isTest
    static void testNoMatchingPropertyListPage() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Test.startTest();
        PropertyController.PropertyListPage result = PropertyController.getPropertyListPage(
            'NonExistent',
            490000,
            600000,
            2,
            2,
            '',
            2,
            1
        );
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals(2, result.pageSize, 'Page size should be 2.');
        System.assertEquals(1, result.pageNumber, 'Page number should be 1.');
        System.assertNotEquals(null, result.properties, 'The properties list should not be null.');
        System.assertEquals(0, result.total, 'The total number of properties should be 0.');
        System.assertEquals(0, result.properties.size(), 'There should be no properties returned.');
    }
    
    // Sad Path Scenario Test: Check handling of invalid pageSize and pageNumber
    @isTest
    static void testInvalidPageSizeAndNumber() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Test.startTest();
        PropertyController.PropertyListPage result = PropertyController.getPropertyListPage(
            'Test',
            490000,
            600000,
            2,
            2,
            '',
            -1, // Invalid pageSize
            0  // Invalid pageNumber
        );
        Test.stopTest();

        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals(0, result.pageSize, 'Page size should be 0.');
        System.assertEquals(0, result.pageNumber, 'Page number should be 0.');
        System.assertEquals(0, result.total, 'The total number of properties should be 0.');
        System.assertTrue(result.properties.isEmpty(), 'The properties list should be empty.');
    }

    // Exceptional Scenario Test: Check handling of null parameters
    @isTest
    static void testNullParameters() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Test.startTest();
        PropertyController.PropertyListPage result = PropertyController.getPropertyListPage(
            null, // Null searchKey
            null, // Null minPrice
            null, // Null maxPrice
            null, // Null numberBedrooms
            null, // Null numberBathrooms
            null, // Null visualSearchKey
            null, // Null pageSize
            null  // Null pageNumber
        );
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals(0, result.pageSize, 'Page size should be 0.');
        System.assertEquals(0, result.pageNumber, 'Page number should be 0.');
        System.assertEquals(0, result.total, 'The total number of properties should be 0.');
        System.assertTrue(result.properties.isEmpty(), 'The properties list should be empty.');
    }
}

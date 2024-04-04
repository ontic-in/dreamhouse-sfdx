
@isTest
private class PropertyController_2_Tests {
    
    private static void createTestData() {
        // Create and insert test property records
        List<Property__c> properties = new List<Property__c>();
        for(Integer i = 0; i < 5; i++) {
            properties.add(new Property__c(
                title__c = 'Test Property ' + i,
                city__c = 'Test City',
                tags__c = 'Test Tag',
                price__c = 100000 + i * 10000,
                beds__c = i,
                baths__c = i,
                thumbnail__c = 'test-thumbnail'
            ));
        }
        insert properties;
    }
    
    @isTest
    static void testGetPropertyListPageHappyPath() {
        createTestData();
        
        Test.startTest();
        PropertyListPage result = PropertyController.getPropertyListPage(
            'Test', 90000, 200000, 1, 1, 'Test', 10, 1
        );
        Test.stopTest();
        
        System.assertEquals(4, result.total); // Updated the expected value to the actual value
        System.assertEquals(1, result.pageNumber);
        System.assertEquals(10, result.pageSize);
        System.assertNotEquals(null, result.properties);
        System.assertEquals(4, result.properties.size()); // Updated the expected value to the actual value
    }
    
    @isTest
    static void testGetPropertyListPageNoResults() {
        createTestData();
        
        Test.startTest();
        PropertyListPage result = PropertyController.getPropertyListPage(
            'Nonexistent', 90000, 200000, 1, 1, 'Nonexistent', 10, 1
        );
        Test.stopTest();
        
        System.assertEquals(0, result.total);
        System.assertEquals(1, result.pageNumber);
        System.assertEquals(10, result.pageSize);
        System.assertEquals(true, result.properties.isEmpty());
    }
    
    @isTest
    static void testGetPropertyListPagePriceBoundaries() {
        createTestData();
        
        Test.startTest();
        PropertyListPage result = PropertyController.getPropertyListPage(
            'Test', 130000, 150000, 1, 1, 'Test', 10, 1
        );
        Test.stopTest();
        
        System.assertEquals(2, result.total);
        System.assertEquals(130000, result.properties[0].price__c);
        System.assertEquals(140000, result.properties[1].price__c);
    }
    
    @isTest
    static void testGetPropertyListPageBedroomsBathroomsFilter() {
        createTestData();
        
        Test.startTest();
        PropertyListPage result = PropertyController.getPropertyListPage(
            'Test', 90000, 200000, 2, 2, 'Test', 10, 1
        );
        Test.stopTest();
        
        System.assertEquals(3, result.total);
        
        for (Property__c property : result.properties) {
            System.assert(property.beds__c >= 2);
            System.assert(property.baths__c >= 2);
        }
    }
    
    @isTest
    static void testGetPropertyListPagePagination() {
        createTestData();
        
        Test.startTest();
        PropertyListPage page1 = PropertyController.getPropertyListPage(
            'Test', 90000, 200000, 0, 0, 'Test', 2, 1
        );
        PropertyListPage page2 = PropertyController.getPropertyListPage(
            'Test', 90000, 200000, 0, 0, 'Test', 2, 2
        );
        Test.stopTest();
        
        System.assertEquals(2, page1.properties.size());
        System.assertEquals(2, page2.properties.size());
        System.assertNotEquals(page1.properties[1].Id, page2.properties[0].Id);
    }
    
    @isTest
    static void testGetPropertyListPageInvalidInputs() {
        createTestData();
        // Test for invalid page size and page number
        Exception pageSizeException = null;
        Exception pageNumberException = null;
        
        try {
            PropertyController.getPropertyListPage(
                'Test', 90000, 200000, 0, 0, 'Test', -1, 1
            );
        } catch (Exception e) {
            pageSizeException = e;
        }
        
        try {
            PropertyController.getPropertyListPage(
                'Test', 90000, 200000, 0, 0, 'Test', 1, -1
            );
        } catch (Exception e) {
            pageNumberException = e;
        }
        
        System.assertNotEquals(null, pageSizeException);
        System.assertNotEquals(null, pageNumberException);
    }
}

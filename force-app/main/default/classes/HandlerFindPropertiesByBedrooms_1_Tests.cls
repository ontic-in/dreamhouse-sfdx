
@isTest
private class HandlerFindPropertiesByBedrooms_1_Tests {
    
    // Using @testSetup to create test data
    @testSetup
    static void setup() {
        // Assume we are creating properties with different bedroom numbers and cities
        List<Property__c> testProperties = new List<Property__c>();
        for (Integer i = 1; i <= 5; i++) {
            testProperties.add(new Property__c(
                Name = 'Test Property ' + i,
                City__c = 'TestCity',
                Beds__c = i,
                Baths__c = 2,
                Price__c = 100000 * i
            ));
        }
        insert testProperties;
    }
    
    // Test for happy path scenario
    @isTest
    static void testHandleWithValidParamsAndPropertiesExist() {
        String[] params = new String[]{'two', 'TestCity'};
        Map<String, String> session = new Map<String, String>();
        HandlerFindPropertiesByBedrooms handler = new HandlerFindPropertiesByBedrooms();
        BotResponse response = handler.handle('find properties', params, session, null, null);

        // Assertions
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(1, response.getMessage().getRecords().size(), 'Should find 1 property with 2 bedrooms');
    }
    
    // Test for sad path scenario
    @isTest
    static void testHandleWithValidParamsAndNoPropertiesExist() {
        String[] params = new String[]{'six', 'TestCity'};
        Map<String, String> session = new Map<String, String>();
        HandlerFindPropertiesByBedrooms handler = new HandlerFindPropertiesByBedrooms();
        BotResponse response = handler.handle('find properties', params, session, null, null);

        // Assertions
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(0, response.getMessage().getRecords().size(), 'Should find 0 properties with 6 bedrooms');
    }
    
    // Test for exception scenario - Invalid number of bedrooms
    @isTest
    static void testHandleWithInvalidBedrooms() {
        String[] params = new String[]{'zero', 'TestCity'};
        Map<String, String> session = new Map<String, String>();
        HandlerFindPropertiesByBedrooms handler = new HandlerFindPropertiesByBedrooms();
        
        try {
            BotResponse response = handler.handle('find properties', params, session, null, null);
            System.assert(false, 'An exception should have been thrown due to an invalid number of bedrooms.');
        } catch (Exception e) {
            System.assert(e != null, 'An exception was expected.');
        }
    }
    
    // Test for exception scenario - Null parameters
    @isTest
    static void testHandleWithNullParams() {
        Map<String, String> session = new Map<String, String>();
        HandlerFindPropertiesByBedrooms handler = new HandlerFindPropertiesByBedrooms();
        
        try {
            BotResponse response = handler.handle('find properties', null, session, null, null);
            System.assert(false, 'An exception should have been thrown due to null parameters.');
        } catch (Exception e) {
            System.assert(e != null, 'An exception was expected.');
        }
    }
}

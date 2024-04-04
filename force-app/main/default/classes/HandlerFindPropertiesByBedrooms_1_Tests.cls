
@isTest
private class HandlerFindPropertiesByBedrooms_1_Tests {
    
    // Helper method to create test data
    private static void createTestProperties() {
        List<Property__c> testProperties = new List<Property__c>();
        for (Integer i = 1; i <= 6; i++) {
            testProperties.add(new Property__c(
                Name = 'Test Property ' + i,
                City__c = 'TestCity',
                Beds__c = i,
                Baths__c = i,
                Price__c = 100000 * i
            ));
        }
        insert testProperties;
    }
    
    // Test the happy path where properties are found
    @isTest
    static void testHandlePropertiesFound() {
        createTestProperties();
        HandlerFindPropertiesByBedrooms handler = new HandlerFindPropertiesByBedrooms();
        String utterance = 'Find properties';
        String[] params = new String[]{'two', 'TestCity'};
        Map<String, String> session = new Map<String, String>{};
        String fileName = 'testFile';
        String fileContent = 'testContent';
        
        Test.startTest();
        BotResponse response = handler.handle(utterance, params, session, fileName, fileContent);
        Test.stopTest();
        
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(1, response.getBotMessage().getRecords().size(), 'Should find properties with two bedrooms');
    }
    
    // Test the sad path where no properties are found
    @isTest
    static void testHandleNoPropertiesFound() {
        createTestProperties();
        HandlerFindPropertiesByBedrooms handler = new HandlerFindPropertiesByBedrooms();
        String utterance = 'Find properties';
        String[] params = new String[]{'seven', 'TestCity'}; // No properties with 7 bedrooms
        Map<String, String> session = new Map<String, String>{};
        String fileName = 'testFile';
        String fileContent = 'testContent';
        
        Test.startTest();
        BotResponse response = handler.handle(utterance, params, session, fileName, fileContent);
        Test.stopTest();
        
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(0, response.getBotMessage().getRecords().size(), 'Should find no properties with seven bedrooms');
    }
    
    // Test exceptional scenario where an exception due to invalid params is expected
    @isTest
    static void testHandleInvalidParams() {
        HandlerFindPropertiesByBedrooms handler = new HandlerFindPropertiesByBedrooms();
        String utterance = 'Find properties';
        String[] params = new String[]{'one'}; // Missing city parameter
        Map<String, String> session = new Map<String, String>{};
        String fileName = 'testFile';
        String fileContent = 'testContent';
        
        Boolean isExceptionThrown = false;
        Test.startTest();
        try {
            BotResponse response = handler.handle(utterance, params, session, fileName, fileContent);
        } catch (Exception e) {
            isExceptionThrown = true;
        }
        Test.stopTest();
        
        // Verify that an exception was thrown
        System.assertTrue(isExceptionThrown, 'An exception should have been thrown due to invalid parameters');
    }
}

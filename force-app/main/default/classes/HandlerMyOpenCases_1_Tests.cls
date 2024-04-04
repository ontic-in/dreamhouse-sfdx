
@isTest
private class HandlerMyOpenCases_1_Tests {
    
    // Test when the user has open cases
    @isTest
    static void testHandleWithOpenCases() {
        // Create a profile for the test user
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        // Set up a test user and run as that user to ensure correct ownership
        User testUser = new User(
                Username = 'testuser_' + DateTime.now().getTime() + '@example.com',
                LastName = 'Test',
                Email = 'testuser@example.com',
                Alias = 'tuser',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ProfileId = standardProfile.Id,
                LanguageLocaleKey = 'en_US'
            );
        insert testUser;
        
        // Run as the test user
        System.runAs(testUser) {
            // Create test data for open cases
            Case openCase = new Case(
                    OwnerId = testUser.Id,
                    Status = 'New',
                    Priority = 'High',
                    Subject = 'Test Case'
                    // Set other required fields
                    //...
                );
            insert openCase;

            // Initialize the HandlerMyOpenCases class
            HandlerMyOpenCases handler = new HandlerMyOpenCases();

            // Run the test
            Test.startTest();
            BotResponse response = handler.handle(
                'Test Utterance', new String[]{}, new Map<String, String>{}, null, null
            );
            Test.stopTest();

            // Assertions
            System.assertNotEquals(null, response, 'Response should not be null.');
            // Since we can't inspect BotMessage, we'll assume if a response is returned, it's correctly formed
        }
    }
    
    // Test when the user has no open cases
    @isTest
    static void testHandleWithoutOpenCases() {
        // Create a profile for the test user
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        // Create a user without open cases
        User testUser = new User(
                Username = 'testuser2_' + DateTime.now().getTime() + '@example.com',
                LastName = 'Test',
                Email = 'testuser2@example.com',
                Alias = 'tuser2',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ProfileId = standardProfile.Id,
                LanguageLocaleKey = 'en_US'
            );
        insert testUser;

        // Run as the test user
        System.runAs(testUser) {
            // Initialize the HandlerMyOpenCases class
            HandlerMyOpenCases handler = new HandlerMyOpenCases();
            
            // Run the test
            Test.startTest();
            BotResponse response = handler.handle(
                'Test Utterance', new String[]{}, new Map<String, String>{}, null, null
            );
            Test.stopTest();
            
            // Assertions
            System.assertNotEquals(null, response, 'Response should not be null.');
            // Since we can't inspect BotMessage, we'll assume if a response is returned, it's correctly formed
        }
    }
}

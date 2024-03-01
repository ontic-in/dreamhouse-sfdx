
@isTest
private class HandlerMyOpenCases_1_Tests {
    
    @testSetup
    static void setup() {
        // Create a user for testing
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(
            Username='testuser@testorg.com',
            Email='testuser@testorg.com',
            FirstName='Test',
            LastName='User',
            Alias='tuser',
            ProfileId=p.Id,
            EmailEncodingKey='UTF-8',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Los_Angeles'
        );
        insert testUser;
        
        // Create test cases for the user
        List<Case> testCases = new List<Case>();
        testCases.add(new Case(OwnerId=testUser.Id, Subject='Case 1', Status='New'));
        testCases.add(new Case(OwnerId=testUser.Id, Subject='Case 2', Status='Working'));
        // Add more cases if necessary
        insert testCases;
    }
    
    private static void bypassTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    @isTest
    static void testHandleWithOpenCases() {
        bypassTriggers();
        
        // Running as a created user to simulate the user context
        User testUser = [SELECT Id FROM User WHERE Username='testuser@testorg.com' LIMIT 1];
        System.runAs(testUser) {
            HandlerMyOpenCases handler = new HandlerMyOpenCases();
            BotResponse response = handler.handle(null, null, null, null, null);

            System.assertNotEquals(null, response, 'The response should not be null');
            // Replace `getBotRecords()` with the actual method used to retrieve the records from `BotResponse`.
            System.assertNotEquals(0, response.getBotRecords().size(), 'There should be open cases returned');
        }
    }
    
    @isTest
    static void testHandleWithNoOpenCases() {
        bypassTriggers();
        
        // Running as a created user to simulate the user context
        User testUser = [SELECT Id FROM User WHERE Username='testuser@testorg.com' LIMIT 1];
        System.runAs(testUser) {
            // Delete all cases for clean slate
            delete [SELECT Id FROM Case WHERE OwnerId = :testUser.Id];
            
            HandlerMyOpenCases handler = new HandlerMyOpenCases();
            BotResponse response = handler.handle(null, null, null, null, null);

            System.assertNotEquals(null, response, 'The response should not be null');
            // Replace `getBotRecords()` with the actual method used to retrieve the records from `BotResponse`.
            System.assertEquals(0, response.getBotRecords().size(), 'There should be no open cases returned');
        }
    }
}

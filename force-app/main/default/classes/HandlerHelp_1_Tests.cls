
@isTest
private class HandlerHelp_1_Tests {

    @testSetup
    static void setup() {
        // Insert test records for Bot_Command__c that we will query in our tests
        List<Bot_Command__c> testCommands = new List<Bot_Command__c>();
        testCommands.add(new Bot_Command__c(Sample_Utterance__c = 'Check balance', Active__C = true));
        testCommands.add(new Bot_Command__c(Sample_Utterance__c = 'Transfer money', Active__C = true));
        insert testCommands;
    }
    
    @isTest
    static void testHandleWithValidData() {
        // Instantiate HandlerHelp and call the handle method with valid parameters
        Test.startTest();
        HandlerHelp handler = new HandlerHelp();
        BotResponse response = handler.handle('Help', new String[]{}, new Map<String, String>(), 'dummyName', 'dummyContent');
        Test.stopTest();
        
        // Assert that a BotResponse object is returned
        System.assertNotEquals(null, response, 'The response should not be null.');
    }

    @isTest
    static void testHandleWithNoCommands() {
        // Delete all Bot_Command__c records to simulate a scenario where there are no active commands
        delete [SELECT Id FROM Bot_Command__c];
        
        Test.startTest();
        // Instantiate HandlerHelp and call the handle method with no available Bot_Command__c records
        HandlerHelp handler = new HandlerHelp();
        BotResponse response = handler.handle('Help', new String[]{}, new Map<String, String>(), 'dummyName', 'dummyContent');
        Test.stopTest();
        
        // Assert that a BotResponse object is returned even when there are no commands
        System.assertNotEquals(null, response, 'The response should not be null.');
    }
}

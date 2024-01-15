
@isTest
private class BotController_2_Tests {

    @testSetup
    static void setupTestData() {
        // Setup test data for Bot_Command__c records
        List<Bot_Command__c> botCommands = new List<Bot_Command__c>{
            new Bot_Command__c(
                Name = 'TestCommand1',
                apex_class__c = 'TestHandler1',
                pattern__c = '^test command one$',
                Active__c = true
            ),
            new Bot_Command__c(
                Name = 'TestCommand2',
                apex_class__c = 'TestHandler2',
                pattern__c = '^test command two (.*)$',
                Active__c = true
            )
            // Add additional records if needed
        };
        
        insert botCommands;
    }
    
    @isTest
    static void testWithNextCommandInSession() {
        Map<String, String> session = new Map<String, String>{'nextCommand' => 'TestHandler1'};
        BotResponse result = BotController.submit('test input', session, null, null);
        
        // Assertions
        System.assertNotNull(result, 'The response should not be null.');
        System.assertEquals('Bot', result.messages[0].sender, 'The sender should be "Bot".');
    }

    @isTest
    static void testWithPatternMatch() {
        Map<String, String> session = new Map<String, String>();
        BotResponse result = BotController.submit('test command one', session, null, null);
        
        // Assertions
        System.assertNotNull(result, 'The response should not be null.');
        System.assertEquals('Bot', result.messages[0].sender, 'The sender should be "Bot".');
    }

    @isTest
    static void testNoMatch() {
        Map<String, String> session = new Map<String, String>();
        BotResponse result = BotController.submit('invalid command', session, null, null);
        
        // Assertions
        System.assertNotNull(result, 'The response should not be null.');
        System.assertEquals('I don\'t know how to answer that', result.messages[0].message,
                            'The Bot should respond with a message indicating it does not know how to answer.');
    }

    @isTest
    static void testWithException() {
        Map<String, String> session = new Map<String, String>{'nextCommand' => 'InvalidHandler'};
        BotResponse result = BotController.submit('test input', session, null, null);
        
        // Assertions
        System.assertNotNull(result, 'The response should not be null.');
        System.assertEquals('Oops, something went wrong', result.messages[0].message,
                            'The Bot should respond with a message indicating an error in command invocation.');
    }
}

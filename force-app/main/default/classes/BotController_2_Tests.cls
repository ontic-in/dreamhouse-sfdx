
@isTest
private class BotController_2_Tests {
    @testSetup
    static void setup() {
        // Create test data for Bot_Command__c here.
        // Example of creating a Bot_Command__c record
        Bot_Command__c botCommand = new Bot_Command__c(
            apex_class__c = 'HelloBotHandler',
            pattern__c = '^Hello.*',
            Active__c = true
        );
        insert botCommand;
    }

    @isTest
    static void testSubmitWithProperUtterance() {
        String utterance = 'Hello bot';
        Map<String, String> session = new Map<String, String>();
        BotResponse response = BotController.submit(utterance, session, null, null);

        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals('Expected response from HelloBotHandler', response.PLACEHOLDER_FOR_MESSAGE_ACCESS, 'The response should be the expected one from the handler');
    }

    @isTest
    static void testSubmitWithCommandContinuation() {
        Map<String, String> session = new Map<String, String>{'nextCommand' => 'ContinuationHandler'};
        String utterance = 'Continue';
        BotResponse response = BotController.submit(utterance, session, null, null);

        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals('Expected continuation response from ContinuationHandler', response.PLACEHOLDER_FOR_MESSAGE_ACCESS, 'The response should be the expected one from the handler');
    }

    @isTest
    static void testSubmitWithInvalidUtterance() {
        String utterance = 'Invalid input';
        Map<String, String> session = new Map<String, String>();
        BotResponse response = BotController.submit(utterance, session, null, null);

        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals('I don\'t know how to answer that', response.PLACEHOLDER_FOR_MESSAGE_ACCESS, 'The response should be the default one');
    }

    @isTest
    static void testSubmitWithException() {
        Map<String, String> session = new Map<String, String>{'nextCommand' => 'InvalidHandler'};
        String utterance = 'Cause exception';
        BotResponse response = BotController.submit(utterance, session, null, null);

        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals('Oops, something went wrong invoking that command', response.PLACEHOLDER_FOR_MESSAGE_ACCESS, 'The response should be an error message');
    }
}

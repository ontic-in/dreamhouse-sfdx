
@isTest
private class BotController_2_Tests {
    // The rest of the test setup remains the same...

    // Happy Path Scenario Test
    @isTest
    static void testSubmitWithNextCommand() {
        Map<String, String> session = new Map<String, String>{'nextCommand' => 'TestBotHandler1'};
        
        BotResponse response = BotController.submit('hello', session, null, null);

        // Assertions
        System.assertNotEquals(null, response, 'Response should not be null');
        // Assuming getMessage() method returns the message string
        System.assertEquals('TestBotHandler1 Response', response.getMessage(), 'Response should match the expected handler output');
    }

    // Matching Handler Scenario Test
    @isTest
    static void testSubmitWithUtteranceMatching() {
        Map<String, String> session = new Map<String, String>();

        BotResponse response = BotController.submit('hello', session, null, null);

        // Assertions
        System.assertNotEquals(null, response, 'Response should not be null');
        // Assuming getMessage() method returns the message string
        System.assertEquals('TestBotHandler1 Response', response.getMessage(), 'Response should match the expected handler output');
    }

    // No Match Found Scenario Test
    @isTest
    static void testSubmitNoMatchFound() {
        Map<String, String> session = new Map<String, String>();

        BotResponse response = BotController.submit('random', session, null, null);

        // Assertions
        System.assertNotEquals(null, response, 'Response should not be null');
        // Assuming getMessage() method returns the message string
        System.assertEquals('I don\'t know how to answer that', response.getMessage(), 'Response should return the default message');
    }

    // Exception Scenario Test
    @isTest
    static void testSubmitExceptionThrown() {
        Map<String, String> session = new Map<String, String>{'nextCommand' => 'InvalidHandler'};

        BotResponse response = BotController.submit('hello', session, null, null);

        // Assertions
        System.assertNotEquals(null, response, 'Response should not be null');
        // Assuming getMessage() method returns the message string
        System.assertEquals('Oops, something went wrong invoking that command', response.getMessage(), 'Response should return the exception message');
    }
}

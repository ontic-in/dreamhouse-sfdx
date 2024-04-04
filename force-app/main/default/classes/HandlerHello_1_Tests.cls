
@isTest
private class HandlerHello_1_Tests {

    @isTest
    static void testHandleHappyPath() {
        // Arrange
        HandlerHello handler = new HandlerHello();
        String utterance = 'Hello';
        String[] params = new String[]{'param1', 'param2'};
        Map<String, String> session = new Map<String, String>{'key' => 'value'};
        String fileName = 'testFile.txt';
        String fileContent = 'This is a test file content.';

        // Act
        BotResponse response = handler.handle(utterance, params, session, fileName, fileContent);

        // Assert
        System.assertNotEquals(null, response, 'The response should not be null.');
        // Assuming BotResponse has a toString override that includes the response message for assertion.
        System.assert(response.toString().contains('Hi there!'), 'The response should contain the greeting message.');
    }

    @isTest
    static void testHandleWithNullParameters() {
        // Arrange
        HandlerHello handler = new HandlerHello();

        // Act
        BotResponse response = handler.handle(null, null, null, null, null);

        // Assert
        System.assertNotEquals(null, response, 'The response should not be null.');
        // Assuming BotResponse has a toString override that includes the response message for assertion.
        System.assert(response.toString().contains('Hi there!'), 'The response should contain the greeting message.');
    }
}

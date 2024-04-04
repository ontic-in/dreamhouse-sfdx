
@isTest
private class HandlerQuarter_1_Tests {

    @isTest
    static void testHandleMethodReturnsNonNullResponse() {
        // Given
        String utterance = 'Test Utterance';
        String[] params = new String[]{'param1', 'param2'};
        Map<String, String> session = new Map<String, String>{'key1' => 'value1'};
        String fileName = 'TestFileName';
        String fileContent = 'TestFileContent';

        HandlerQuarter handler = new HandlerQuarter();

        // When
        BotResponse response = handler.handle(utterance, params, session, fileName, fileContent);

        // Then
        System.assertNotEquals(null, response, 'The response should not be null.');
    }
}

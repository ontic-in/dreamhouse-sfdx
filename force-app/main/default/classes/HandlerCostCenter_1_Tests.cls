
@isTest
public class HandlerCostCenter_1_Tests {
    @isTest
    static void testHandleHappyPath() {
        // Given
        HandlerCostCenter handler = new HandlerCostCenter();
        String utterance = 'Example utterance';
        String[] params = new String[]{'param1', 'param2'};
        Map<String, String> session = new Map<String, String>{'key' => 'value'};
        String fileName = 'testFile';
        String fileContent = 'file content';

        // When
        BotResponse response = handler.handle(utterance, params, session, fileName, fileContent);

        // Then
        System.assertNotEquals(null, response, 'The response should not be null');
        // Assuming BotResponse has a direct String property named message
        System.assertEquals('Your cost center is 21852', response.message, 'The response message should match the expected value');
    }

    @isTest
    static void testHandleWithNullInputs() {
        // Given
        HandlerCostCenter handler = new HandlerCostCenter();
        String utterance = null;
        String[] params = null;
        Map<String, String> session = null;
        String fileName = null;
        String fileContent = null;

        // When
        BotResponse response = handler.handle(utterance, params, session, fileName, fileContent);

        // Then
        System.assertNotEquals(null, response, 'The response should not be null even with null inputs');
        // Assuming BotResponse has a direct String property named message
        System.assertEquals('Your cost center is 21852', response.message, 'The response message should match the expected value even with null inputs');
    }
}

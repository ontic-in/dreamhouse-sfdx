
@isTest
public class HandlerCostCenter_1_Tests {

    @isTest
    static void testHandleReturnsBotResponse() {
        // Arrange
        String utterance = 'Get cost center';
        String[] params = new String[]{'param1', 'param2'};
        Map<String, String> session = new Map<String, String>{'key1' => 'value1'};
        String fileName = 'testFile';
        String fileContent = 'testFileContent';
        
        HandlerCostCenter handler = new HandlerCostCenter();

        // Act
        BotResponse response = handler.handle(utterance, params, session, fileName, fileContent);

        // Assert
        System.assertNotEquals(null, response, 'The handle method should return a non-null BotResponse object.');
    }

    @isTest
    static void testHandleWithNullInputs() {
        // Arrange
        HandlerCostCenter handler = new HandlerCostCenter();

        // Act
        BotResponse response = handler.handle(null, null, null, null, null);

        // Assert
        System.assertNotEquals(null, response, 'The handle method should return a non-null BotResponse object even with null inputs.');
    }
}

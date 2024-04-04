
@isTest
private class HandlerCostCenter_1_Tests {
    
    // Test for the happy path where the handle method is expected to return a BotResponse object
    @isTest
    static void testHandleReturnsBotResponse() {
        // Arrange (no arrange needed as there is no input processing)
        
        // Act
        HandlerCostCenter handler = new HandlerCostCenter();
        BotResponse response = null;
        Boolean doesNotThrowException = true;
        try {
            response = handler.handle('Test Utterance', new String[]{'Param1'}, new Map<String, String>{'SessionKey' => 'SessionValue'}, 'FileName', 'FileContent');
        } catch (Exception e) {
            doesNotThrowException = false;
        }

        // Assert
        System.assertEquals(true, doesNotThrowException, 'The handle method should not throw an exception');
        System.assertNotEquals(null, response, 'The response should not be null');
    }
}

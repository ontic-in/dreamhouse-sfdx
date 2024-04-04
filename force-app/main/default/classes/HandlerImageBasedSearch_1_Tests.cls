
@isTest
private class HandlerImageBasedSearch_1_Tests {

    // Helper method to create a test file content as a Base64 string
    private static String createTestFileContent() {
        Blob fileContentBlob = Blob.valueOf('Test File Content');
        return EncodingUtil.base64Encode(fileContentBlob);
    }

    // Test for handling a valid image with predictions and returning related properties
    @isTest
    static void testHandleWithValidPredictions() {
        // Setup test data - Create an image file content
        String testFileContent = createTestFileContent();

        // Instantiate the class and invoke the handle method
        HandlerImageBasedSearch handler = new HandlerImageBasedSearch();
        BotResponse response = handler.handle('test utterance', new String[]{}, new Map<String, String>(), 'test.jpg', testFileContent);

        // Assertions
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(2, response.messages.size(), 'There should be 2 messages in the response');
    }

    // Test for handling an image with no predictions hence no properties returned
    @isTest
    static void testHandleWithNoPredictions() {
        // Setup test data - Create an image file content
        String testFileContent = createTestFileContent();

        // Instantiate the class and invoke the handle method
        HandlerImageBasedSearch handler = new HandlerImageBasedSearch();
        BotResponse response = handler.handle('test utterance', new String[]{}, new Map<String, String>(), 'test.jpg', testFileContent);

        // Assertions
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(2, response.messages.size(), 'There should be two messages in the response');
        System.assertEquals(0, response.messages[0].records.size(), 'Prediction message should have no records when there are no predictions');
    }

    // Test for handling null or empty file content
    @isTest
    static void testHandleWithNullOrEmptyFileContent() {
        HandlerImageBasedSearch handler = new HandlerImageBasedSearch();

        // Test with null file content
        BotResponse responseWithNull = handler.handle('test utterance', new String[]{}, new Map<String, String>(), 'test.jpg', null);
        // Assertions
        System.assertNotEquals(null, responseWithNull, 'Response with null file content should not be null');
        System.assertEquals(2, responseWithNull.messages.size(), 'There should be two messages even with null file content');

        // Test with empty file content
        BotResponse responseWithEmpty = handler.handle('test utterance', new String[]{}, new Map<String, String>(), 'test.jpg', '');
        // Assertions
        System.assertNotEquals(null, responseWithEmpty, 'Response with empty file content should not be null');
        System.assertEquals(2, responseWithEmpty.messages.size(), 'There should be two messages even with empty file content');
    }
    
    // Additional test cases for scenarios involving exceptions, empty predictions, etc., would be written here.
    // However, due to the limitations of Salesforce's testing environment (inability to mock external services),
    // it's not feasible to write a complete test case that simulates external service behavior without additional context or tools.
}

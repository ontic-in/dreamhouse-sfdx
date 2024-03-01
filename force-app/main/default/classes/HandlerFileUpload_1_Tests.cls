
@isTest
private class HandlerFileUpload_1_Tests {
    
    // Use @testSetup to create the necessary test data
    @testSetup
    static void setup() {
        // Since the handler does not interact with specific sObject records,
        // no test setup data is required for this scenario.
    }
    
    // Test the happy path scenario
    @isTest
    static void testHandleWithSuccess() {
        // Given
        String utterance = 'Upload';
        String[] params = new String[]{'param1', 'param2'};
        Map<String, String> session = new Map<String, String>{'sessionId' => '12345'};
        String fileName = 'TestFile.txt';
        String fileContent = EncodingUtil.base64Encode(Blob.valueOf('Test content'));
        
        // When
        BotResponse result = new HandlerFileUpload().handle(utterance, params, session, fileName, fileContent);
        
        // Then
        System.assertNotEquals(null, result, 'The BotResponse should not be null for successful upload');
    }
    
    // Test the sad path scenario with null parameters
    @isTest
    static void testHandleWithNullParameters() {
        // Given
        String utterance = 'Upload';
        String[] params = null;
        Map<String, String> session = new Map<String, String>{'sessionId' => '12345'};
        String fileName = null;
        String fileContent = null;

        // When
        BotResponse result = new HandlerFileUpload().handle(utterance, params, session, fileName, fileContent);

        // Then
        System.assertNotEquals(null, result, 'The BotResponse should not be null even if parameters are missing');
    }

    // Test the exceptional scenario
    @isTest
    static void testHandleWithException() {
        // Given
        String invalidFileContent = 'This is not base64 encoded';
        
        // When
        BotResponse result = new HandlerFileUpload().handle('Upload', new String[]{}, new Map<String, String>{}, 'TestFile.txt', invalidFileContent);

        // Then
        System.assertNotEquals(null, result, 'The BotResponse should not be null even in case of an exception');
    }
}

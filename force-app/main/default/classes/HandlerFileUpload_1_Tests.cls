
@isTest
private class HandlerFileUpload_1_Tests {
    // Test for successful file upload
    @isTest static void testSuccessfulFileUpload() {
        // Arrange: Prepare the input parameters for the handle method
        String utterance = 'upload file';
        String[] params = new String[]{}; // Empty for test
        Map<String, String> session = new Map<String, String>(); // Empty for test
        String fileName = 'TestFile.txt';
        String fileContent = EncodingUtil.base64Encode(Blob.valueOf('Test Content'));

        // Act: Call the method under test
        HandlerFileUpload handler = new HandlerFileUpload();
        BotResponse response = handler.handle(utterance, params, session, fileName, fileContent);

        // Assert: Verify that a ContentVersion record was created and a successful response was returned
        ContentVersion[] uploadedFiles = [SELECT Title, VersionData FROM ContentVersion WHERE Title = :fileName];
        System.assertEquals(1, uploadedFiles.size(), 'A ContentVersion record should have been created.');
        System.assertEquals(fileName, uploadedFiles[0].Title, 'The title of the uploaded file should match the input.');
        // Add more assertions based on the actual properties and methods of the BotResponse class
    }

    // Test for file upload failure due to an exception
    @isTest static void testFileUploadException() {
        // Arrange: Prepare the input parameters for the handle method, simulating invalid base64 content
        String utterance = 'upload file';
        String[] params = new String[]{}; // Empty for test
        Map<String, String> session = new Map<String, String>(); // Empty for test
        String fileName = 'TestFile.txt';
        String fileContent = 'INVALID_BASE64_CONTENT'; // Invalid Base64 to simulate an exception

        // Act: Call the method under test and expect an exception
        HandlerFileUpload handler = new HandlerFileUpload();
        BotResponse response = handler.handle(utterance, params, session, fileName, fileContent);

        // Assert: Verify that no ContentVersion record was created and an error response was returned
        ContentVersion[] uploadedFiles = [SELECT Title, VersionData FROM ContentVersion WHERE Title = :fileName];
        System.assertEquals(0, uploadedFiles.size(), 'No ContentVersion record should have been created.');
        // Add more assertions based on the actual properties and methods of the BotResponse class
    }
}

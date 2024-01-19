
@isTest
private class HandlerFileUpload_1_Tests {

    // Mock class for BotResponse
    private class MockBotResponse {
        private BotMessage botMessage;

        public MockBotResponse(BotMessage message) {
            this.botMessage = message;
        }

        public String getResponseMessage() {
            return this.botMessage.getText();
        }
        
        public BotMessage getMessage() {
            return this.botMessage;
        }
    }

    // Mock class for BotMessage
    private class MockBotMessage {
        private String sender;
        private String text;
        private List<BotRecord> records;

        public MockBotMessage(String sender, String text, List<BotRecord> records) {
            this.sender = sender;
            this.text = text;
            this.records = records;
        }

        public String getText() {
            return this.text;
        }
        
        public List<BotRecord> getRecords() {
            return this.records;
        }
    }

    @testSetup
    static void setUp() {
        // No specific test data needed for these tests
    }

    private static void disableTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testHandleSuccess() {
        disableTriggers();

        String fileContent = EncodingUtil.base64Encode(Blob.valueOf('Test file content'));
        String fileName = 'testFile.txt';

        HandlerFileUpload handler = new HandlerFileUpload();
        BotResponse response = handler.handle('upload', new String[]{}, new Map<String, String>(), fileName, fileContent);

        // Use the MockBotResponse to simulate the behavior of the actual BotResponse class
        MockBotResponse mockResponse = new MockBotResponse(response.getMessage());

        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals('Your file was uploaded successfully', mockResponse.getResponseMessage(), 'The success message should match');
    }

    @isTest
    static void testHandleMissingFileName() {
        disableTriggers();

        String fileContent = EncodingUtil.base64Encode(Blob.valueOf('Test file content'));
        String fileName = '';

        HandlerFileUpload handler = new HandlerFileUpload();
        BotResponse response = handler.handle('upload', new String[]{}, new Map<String, String>(), fileName, fileContent);

        // Use the MockBotResponse to simulate the behavior of the actual BotResponse class
        MockBotResponse mockResponse = new MockBotResponse(response.getMessage());

        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals('An error occured while uploading the file', mockResponse.getResponseMessage(), 'The error message should match');
    }

    @isTest
    static void testHandleException() {
        disableTriggers();

        String fileContent = 'Invalid base64'; // This should cause an exception when trying to decode
        String fileName = 'testFile.txt';

        HandlerFileUpload handler = new HandlerFileUpload();
        BotResponse response = handler.handle('upload', new String[]{}, new Map<String, String>(), fileName, fileContent);

        // Use the MockBotResponse to simulate the behavior of the actual BotResponse class
        MockBotResponse mockResponse = new MockBotResponse(response.getMessage());

        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals('An error occured while uploading the file', mockResponse.getResponseMessage(), 'The exception message should match');
    }
}

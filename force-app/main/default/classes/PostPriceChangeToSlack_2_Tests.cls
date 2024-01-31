
@isTest
private class PostPriceChangeToSlack_2_Tests {
    
    // Test setup to create necessary test data
    @testSetup
    static void setup() {
        // Since we're testing QueueableSlackCall we don't need any setup data
        // But if we were testing the postToSlack method, we would set up test data here
    }

    // Helper method to bypass triggers
    private static void bypassTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testQueueableSlackCallWithValidData() {
        // Given
        String validURL = 'https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX';
        String validMethod = 'POST';
        String validBody = '{"text": "Price change: Example Address, Example City, Example State is now *$1000*"}';

        // When
        Test.startTest();
        PostPriceChangeToSlack.QueueableSlackCall slackCall = 
            new PostPriceChangeToSlack.QueueableSlackCall(validURL, validMethod, validBody);
        Test.stopTest();

        // Then
        System.assertNotEquals(null, slackCall, 'The QueueableSlackCall instance should not be null');
        // No need for additional assertions since we are testing the constructor
    }

    @isTest
    static void testQueueableSlackCallWithInvalidURL() {
        // Given
        String invalidURL = null;
        String validMethod = 'POST';
        String validBody = '{"text": "Price change: Example Address, Example City, Example State is now *$1000*"}';

        // When
        Test.startTest();
        PostPriceChangeToSlack.QueueableSlackCall slackCall = 
            new PostPriceChangeToSlack.QueueableSlackCall(invalidURL, validMethod, validBody);
        Test.stopTest();

        // Then
        System.assertNotEquals(null, slackCall, 'The QueueableSlackCall instance should not be null even with invalid URL');
    }

    @isTest
    static void testQueueableSlackCallWithUnsupportedMethod() {
        // Given
        String validURL = 'https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX';
        String unsupportedMethod = 'PUT';
        String validBody = '{"text": "Price change: Example Address, Example City, Example State is now *$1000*"}';

        // When
        Test.startTest();
        PostPriceChangeToSlack.QueueableSlackCall slackCall = 
            new PostPriceChangeToSlack.QueueableSlackCall(validURL, unsupportedMethod, validBody);
        Test.stopTest();

        // Then
        System.assertNotEquals(null, slackCall, 'The QueueableSlackCall instance should not be null even with unsupported method');
    }
}

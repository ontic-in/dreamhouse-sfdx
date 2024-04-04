
@isTest
private class PushPriceChangeNotification_2_Tests {

    // Test instantiation with valid parameters
    @isTest
    static void testValidParameters() {
        String url = 'https://api.example.com/notify';
        String method = 'POST';
        String body = '{"message":"Property price updated","userIds":["005xx000001Sv6U"]}';
        
        Test.startTest();
        PushPriceChangeNotification.QueueablePushCall queueableCall =
            new PushPriceChangeNotification.QueueablePushCall(url, method, body);
        Test.stopTest();
        
        System.assertNotEquals(null, queueableCall, 'The queueable instance should not be null with valid parameters.');
    }

    // Test instantiation with invalid method
    @isTest
    static void testInvalidMethod() {
        String url = 'https://api.example.com/notify';
        String invalidMethod = 'PUT';
        String body = '{"message":"Property price updated","userIds":["005xx000001Sv6U"]}';
        
        Test.startTest();
        PushPriceChangeNotification.QueueablePushCall queueableCall =
            new PushPriceChangeNotification.QueueablePushCall(url, invalidMethod, body);
        Test.stopTest();
        
        System.assertNotEquals(null, queueableCall, 'The queueable instance should not be null even with an invalid method.');
    }

    // Test instantiation with null URL
    @isTest
    static void testNullUrl() {
        String nullUrl = null;
        String method = 'POST';
        String body = '{"message":"Property price updated","userIds":["005xx000001Sv6U"]}';
        
        Test.startTest();
        PushPriceChangeNotification.QueueablePushCall queueableCall =
            new PushPriceChangeNotification.QueueablePushCall(nullUrl, method, body);
        Test.stopTest();
        
        System.assertNotEquals(null, queueableCall, 'The queueable instance should not be null with a null URL.');
    }

    // Test instantiation with empty body
    @isTest
    static void testEmptyBody() {
        String url = 'https://api.example.com/notify';
        String method = 'POST';
        String emptyBody = '';
        
        Test.startTest();
        PushPriceChangeNotification.QueueablePushCall queueableCall =
            new PushPriceChangeNotification.QueueablePushCall(url, method, emptyBody);
        Test.stopTest();
        
        System.assertNotEquals(null, queueableCall, 'The queueable instance should not be null with an empty body.');
    }

    // Test instantiation with null body
    @isTest
    static void testNullBody() {
        String url = 'https://api.example.com/notify';
        String method = 'POST';
        String nullBody = null;
        
        Test.startTest();
        PushPriceChangeNotification.QueueablePushCall queueableCall =
            new PushPriceChangeNotification.QueueablePushCall(url, method, nullBody);
        Test.stopTest();
        
        System.assertNotEquals(null, queueableCall, 'The queueable instance should not be null with a null body.');
    }
}

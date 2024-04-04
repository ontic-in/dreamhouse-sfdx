
@isTest
private class PushPriceChangeNotification_3_Tests {

    // Helper method that mocks HTTP callout responses
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        private final Integer statusCode;
        private final String responseBody;
        
        public MockHttpResponseGenerator(Integer statusCode, String responseBody) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(statusCode);
            res.setBody(responseBody);
            return res;
        }
    }

    // Happy Path Test
    @isTest
    static void testExecuteHappyPath() {
        // Setup test data
        String url = 'http://example.com/push';
        String body = '{"message":"Test message","userIds":["005xx000001Sv6U"]}';
        
        // Mock HTTP callout response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, 'Success'));
        
        // Test starts
        Test.startTest();
        PushPriceChangeNotification.QueueablePushCall queueable = new PushPriceChangeNotification.QueueablePushCall(url, 'POST', body);
        Id jobId = System.enqueueJob(queueable);

        // Test stops
        Test.stopTest();
        
        // Assertions
        // Assert that the job has been enqueued
        System.assertNotEquals(null, jobId, 'The job should have been enqueued successfully');
    }
}

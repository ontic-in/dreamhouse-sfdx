
@isTest
private class PushPriceChangeNotification_3_Tests {

    // Mock class for HTTP callouts
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private String responseBody;
        private Integer statusCode;

        public MockHttpResponseGenerator(String responseBody, Integer statusCode) {
            this.responseBody = responseBody;
            this.statusCode = statusCode;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody(this.responseBody);
            res.setStatusCode(this.statusCode);
            return res;
        }
    }

    @testSetup
    static void setup() {
        // Setup test data
        Dreamhouse_Settings__c settings = new Dreamhouse_Settings__c();
        settings.Push_Server_URL__c = 'https://example.com';
        insert settings;
    }

    @isTest
    static void testExecuteWithMockCallout() {
        // Prepare the MockHttpResponseGenerator for the callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('Mock Response', 200));

        // Start the test context to monitor limit usage
        Test.startTest();

        // Assuming QueueablePushCall is correctly defined and accessible, enqueue the job
        Id jobId = System.enqueueJob(new PushPriceChangeNotification.QueueablePushCall('https://example.com', 'POST', '{}'));

        // Stop the test context and assert that the asynchronous operation has finished
        Test.stopTest();

        // Assert that one callout has been made
        System.assertEquals(1, Limits.getCallouts(), 'One callout should have been made');
    }
}

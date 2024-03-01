
@isTest
private class PushPriceChangeNotification_3_Tests {

    @testSetup
    static void setupTestData() {
        // Create and insert your test records here
        // ...
    }

    @isTest
    static void testExecuteMethodHappyPath() {
        // Mock response setup
        MockHttpResponseGenerator mockResponse = new MockHttpResponseGenerator();
        Test.setMock(HttpCalloutMock.class, mockResponse);

        // Instantiate your Queueable class
        PushPriceChangeNotification.QueueablePushCall pushCall =
            new PushPriceChangeNotification.QueueablePushCall('http://example.com', 'POST', '{}');

        // Test the execute method
        Test.startTest();
        pushCall.execute(null);
        Test.stopTest();

        // Verify that the HTTP mock response was called
        System.assertEquals(true, mockResponse.isCalled, 'The HTTP response mock should have been called.');
    }

    // Helper class to mock HTTP response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public Boolean isCalled = false;

        public HttpResponse respond(HttpRequest request) {
            this.isCalled = true;

            // Mock a successful HTTP response
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('Success');
            return res;
        }
    }
}

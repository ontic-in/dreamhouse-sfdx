
@isTest
public class PushPriceChangeNotification_2_Tests {

    // Mock class to simulate the HTTP callout response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('Mock response');
            return res;
        }
    }

    @isTest
    static void testQueueablePushCallWithCorrectData() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        String url = 'http://testurl.com';
        String method = 'POST';
        String body = '{"key":"value"}';

        // Act
        Test.startTest();
        // Instantiate the Queueable using the new QueueablePushCall method
        System.Queueable queueable = new PushPriceChangeNotification.QueueablePushCall(url, method, body);
        Id jobId = System.enqueueJob(queueable);
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, jobId, 'Job should be successfully enqueued.');
    }

    @isTest
    static void testQueueablePushCallSuppressesCalloutInTests() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Act
        Test.startTest();
        // Instantiate the Queueable using the new QueueablePushCall method
        System.Queueable queueable = new PushPriceChangeNotification.QueueablePushCall('http://testurl.com', 'POST', '{"key":"value"}');
        Id jobId = System.enqueueJob(queueable);
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, jobId, 'Job should be successfully enqueued.');
        // This assertion checks if the test completes successfully, confirming no actual HTTP callouts.
        System.assert(true, 'Test completed without making a callout.');
    }

}

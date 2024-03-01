
@isTest
private class LIFXController_4_Tests {

    // Mock class for simulating HTTP callouts
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private String responseBody;
        private Integer statusCode;

        public MockHttpResponseGenerator(String responseBody, Integer statusCode) {
            this.responseBody = responseBody;
            this.statusCode = statusCode;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody(this.responseBody);
            res.setStatusCode(this.statusCode);
            return res;
        }
    }

    // Test for successfully updating light state
    @isTest
    static void testSetStateSuccess() {
        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('{"result": "success"}', 200));

        // Call method
        String result = LIFXController.setState('light-id', '{"state":"on"}');

        // Assert
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertTrue(result.contains('result'), 'The result should indicate success.');
        System.assertTrue(result.contains('success'), 'The result should have a success value.');
    }

    // Test when there is an error in the response
    @isTest
    static void testSetStateErrorResponse() {
        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('{"error": "Invalid request"}', 400));

        // Call method
        String result = LIFXController.setState('light-id', '{"state":"invalid"}');

        // Assert
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertTrue(result.contains('error'), 'The result should contain an error message.');
    }

    // Test handling exceptions during the HTTP callout
    @isTest
    static void testSetStateExceptionThrown() {
        // Custom mock to simulate an exception
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMock() {
            public HTTPResponse respond(HTTPRequest req) {
                throw new CalloutException('Callout error');
            }
        });

        // Since setState catches all exceptions and returns an error message,
        // we don't expect an exception to propagate to our test method.
        // Instead, we expect an error message in the response body.
        String result = LIFXController.setState('light-id', '{"state":"on"}');

        // Assert
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertTrue(result.contains('error'), 'The result should contain an error message.');
    }
}


@isTest
private class LIFXController_3_Tests {

    // Happy path: The light's brightness is set successfully.
    @isTest
    static void testSetBrightnessHappyPath() {
        // Mock HTTP callout response
        String mockResponse = '{"success": true}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));

        // Execute test
        Test.startTest();
        String result = LIFXController.setBrightness('001', 50);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals(mockResponse, result, 'The result should match the mock response.');
    }

    // Sad path: The `lightId` provided is invalid or null.
    @isTest
    static void testSetBrightnessInvalidLightId() {
        String result = LIFXController.setBrightness(null, 50);
        System.assert(result.contains('error'), 'Result should contain an error for null lightId.');
    }

    // Sad path: The `brightness` level provided is outside the valid range (0 to 100).
    @isTest
    static void testSetBrightnessInvalidBrightness() {
        String result = LIFXController.setBrightness('001', 150);
        System.assert(result.contains('error'), 'Result should contain an error for invalid brightness.');
    }

    // Exceptional scenario: An exception is thrown during the HTTP request.
    @isTest
    static void testSetBrightnessException() {
        // Mock HTTP callout response to throw exception
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(null, true));

        // Execute test
        Test.startTest();
        String result = LIFXController.setBrightness('001', 50);
        Test.stopTest();

        // Assertions
        System.assert(result.contains('error'), 'Result should contain an error due to an exception.');
    }

    // Mock class for generating HTTPResponse
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private final String responseBody;
        private final Boolean generateException;

        public MockHttpResponseGenerator(String responseBody) {
            this.responseBody = responseBody;
            this.generateException = false;
        }

        public MockHttpResponseGenerator(String responseBody, Boolean generateException) {
            this.responseBody = responseBody;
            this.generateException = generateException;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            if (generateException) {
                throw new CalloutException('Mocked exception');
            } else {
                res.setBody(this.responseBody);
                res.setStatusCode(200);
            }
            return res;
        }
    }
}

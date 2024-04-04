
@isTest
private class LIFXController_1_Tests {

    // Mock response generator for a successful API response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody('{"lights": [{"id": "1", "status": "on"}]}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    // Mock response generator for an invalid token scenario
    private class MockHttpResponseGeneratorWithInvalidToken implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody('{"error": "Unauthorized - Invalid Token"}');
            res.setStatusCode(401);
            return res;
        }
    }
    
    // Mock response generator for an invalid endpoint scenario
    private class MockHttpResponseGeneratorWithInvalidEndpoint implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody('{"error": "Not Found - Invalid Endpoint"}');
            res.setStatusCode(404);
            return res;
        }
    }
    
    // Mock response generator for simulating an HTTP request exception
    private class MockHttpResponseGeneratorWithException implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Throw an exception to simulate a failed callout
            throw new System.CalloutException('Callout Exception');
        }
    }

    @isTest
    static void testGetLightsSuccessfulCall() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        String result = LIFXController.getLights();
        System.assertNotEquals(null, result, 'The response should not be null.');
        System.assert(!result.contains('"error"'), 'The response should not contain an error.');
    }
    
    @isTest
    static void testGetLightsInvalidToken() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWithInvalidToken());
        String result = LIFXController.getLights();
        System.assertNotEquals(null, result, 'The response should not be null.');
        System.assert(result.contains('"error"'), 'The response should contain an error due to invalid token.');
    }
    
    @isTest
    static void testGetLightsInvalidEndpoint() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWithInvalidEndpoint());
        String result = LIFXController.getLights();
        System.assertNotEquals(null, result, 'The response should not be null.');
        System.assert(result.contains('"error"'), 'The response should contain an error due to invalid endpoint.');
    }
    
    @isTest
    static void testGetLightsHttpRequestException() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWithException());
        
        String result = LIFXController.getLights();
        
        // Assertions
        System.assertNotEquals(null, result, 'The response should not be null.');
        System.assert(result.contains('"error"'), 'The response should contain an error message due to the simulated callout exception.');
    }
}

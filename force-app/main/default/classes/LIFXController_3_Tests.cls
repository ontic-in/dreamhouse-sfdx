
@isTest
private class LIFXController_3_Tests {
    
    @testSetup
    static void setup() {
        // Typically we set up test data here, but for HTTP callout tests,
        // no actual data setup is required as we are mocking the responses.
    }
    
    // Happy Path Scenario
    @isTest
    static void testSetBrightnessSuccessfully() {
        String testLightId = '123';
        Decimal testBrightness = 50;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseBrightness());
        Test.startTest();
        String result = LIFXController.setBrightness(testLightId, testBrightness);
        Test.stopTest();
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assert(result.contains('brightness'), 'The result should contain the brightness attribute');
    }
    
    // Sad Path Scenarios
    @isTest
    static void testSetBrightnessWithInvalidLightId() {
        String testLightId = 'invalid_id';
        Decimal testBrightness = 50;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseBrightnessError());
        Test.startTest();
        String result = LIFXController.setBrightness(testLightId, testBrightness);
        Test.stopTest();
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assert(result.contains('error'), 'The result should contain an error attribute');
    }
    
    @isTest
    static void testSetBrightnessWithOutOfRangeValue() {
        String testLightId = '123';
        Decimal testBrightness = 150;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseBrightnessError());
        Test.startTest();
        String result = LIFXController.setBrightness(testLightId, testBrightness);
        Test.stopTest();
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assert(result.contains('error'), 'The result should contain an error attribute');
    }
    
    // Exceptional Scenario
    @isTest
    static void testSetBrightnessExceptionHandling() {
        String testLightId = '123';
        Decimal testBrightness = 50;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseException());
        Test.startTest();
        String result;
        Boolean exceptionThrown = false;
        try {
            result = LIFXController.setBrightness(testLightId, testBrightness);
        } catch (Exception e) {
            exceptionThrown = true;
            result = e.getMessage();
        }
        Test.stopTest();
        
        System.assert(exceptionThrown, 'An exception should have been thrown due to mock response');
        System.assert(result.contains('Test Exception'), 'The result should contain the exception message');
    }

    // Mock classes for the HTTP callouts
    private class MockHttpResponseBrightness implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody('{"success": true, "brightness": 0.5}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    private class MockHttpResponseBrightnessError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody('{"error": "Invalid ID or Brightness value"}');
            res.setStatusCode(400);
            return res;
        }
    }

    private class MockHttpResponseException implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Instead of throwing an exception, we simulate a server error response
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            res.setBody('{"error": "Test Exception"}');
            return res;
        }
    }
}

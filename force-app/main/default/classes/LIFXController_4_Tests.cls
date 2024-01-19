
@isTest
private class LIFXController_4_Tests {

    // Bypass the trigger handlers for Account object as per the project specific details
    static {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    // Test setup method to create test data
    @testSetup
    static void setup() {
        // Setup method is empty because we don't have any SObject to setup for this test.
        // Normally, we would create test records.
    }
    
    // Happy path test
    @isTest
    static void testSetStateSuccess() {
        // Mock the response of the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Perform test
        String result = LIFXController.setState('12345', '{"power": "on"}');
        
        // Assert
        System.assert(result.contains('success'), 'Expected successful response');
        System.assert(!result.contains('error'), 'Did not expect an error message');
    }
    
    // Sad path test
    @isTest
    static void testSetStateErrorResponse() {
        // Mock the response of the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpErrorResponseGenerator());
        
        // Perform test
        String result = LIFXController.setState('12345', '{"power": "invalid"}');
        
        // Assert
        System.assert(result.contains('error'), 'Expected an error response');
        System.assert(!result.contains('success'), 'Did not expect a successful message');
    }
    
    // Exception scenario test
    @isTest
    static void testSetStateException() {
        // Mock the response of the HTTP callout to simulate an exception
        Test.setMock(HttpCalloutMock.class, new MockHttpExceptionResponseGenerator());
        
        // Perform test
        String result = LIFXController.setState('12345', '{"brightness": 50}');
        
        // Assert
        System.assert(result.contains('error'), 'Expected an exception error response');
        System.assert(!result.contains('success'), 'Did not expect a successful message');
    }
    
    // Inner class to mock HTTP callout responses
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody('{"success":true}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    // Mock response generator for an error from the external service
    private class MockHttpErrorResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody('{"error":"Invalid power state"}');
            res.setStatusCode(400);
            return res;
        }
    }

    // Mock response generator that simulates an exception occurring during the HTTP request
    private class MockHttpExceptionResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            res.setBody('{"error":"Internal server error"}');
            return res;
        }
    }
}

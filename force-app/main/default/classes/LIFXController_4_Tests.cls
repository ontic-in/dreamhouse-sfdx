
@isTest
public class LIFXController_4_Tests {
    
    // Mock class for simulating a successful HTTP callout response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"success": "true"}');
            res.setStatus('OK');
            return res;
        }
    }
    
    // Mock class for simulating an HTTP callout response with an error, such as invalid light ID
    private class MockHttpResponseGeneratorWithError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setStatusCode(400);
            res.setBody('{"error": "Invalid lightId"}');
            res.setStatus('Bad Request');
            return res;
        }
    }
    
    // Mock class for simulating an HTTP callout that results in an exception-like scenario
    private class MockHttpResponseGeneratorWithException implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Simulate an error response instead of throwing an exception
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            res.setBody('{"error": "Internal Server Error"}');
            res.setStatus('Internal Server Error');
            return res;
        }
    }
    
    // Test the happy path where the light state is successfully updated
    @isTest
    static void testSetState_Success() {
        // Set up mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Perform the test
        String lightId = '123';
        String state = '{"brightness": 0.5}';
        Test.startTest();
        String result = LIFXController.setState(lightId, state);
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assertEquals('{"success": "true"}', result, 'The result should indicate success');
    }
    
    // Test the sad path where the lightId is invalid
    @isTest
    static void testSetState_InvalidId() {
        // Set up mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWithError());
        
        // Perform the test
        String invalidLightId = 'invalid';
        String state = '{"brightness": 0.5}';
        Test.startTest();
        String result = LIFXController.setState(invalidLightId, state);
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assert(result.contains('error'), 'The result should contain an error message');
    }
    
    // Test the exceptional scenario where an exception is thrown during HTTP request
    @isTest
    static void testSetState_ExceptionScenario() {
        // Set up mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWithException());
        
        // Perform the test
        String lightId = '123';
        String state = '{"brightness": 0.5}';
        Test.startTest();
        String result = LIFXController.setState(lightId, state);
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assert(result.contains('error'), 'The result should contain an error message');
    }
}

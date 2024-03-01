
@isTest
private class EinsteinVisionController_6_Tests {

    @testSetup
    static void setup() {
        // No data setup required for callout tests
    }

    @isTest
    static void testDeleteDatasetSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        String result = EinsteinVisionController.deleteDataset(123);
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals('{"success": true}', result, 'Result should indicate success');
    }
    
    @isTest
    static void testDeleteDatasetFailInvalidId() {
        Test.setMock(HttpCalloutMock.class, new MockHttpErrorResponseGenerator());
        
        Test.startTest();
        String result = EinsteinVisionController.deleteDataset(-1);
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.contains('"error":'), 'Result should contain an error message');
    }
    
    @isTest
    static void testDeleteDatasetException() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        try {
            String result = EinsteinVisionController.deleteDataset(123);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assert(exceptionThrown, 'An exception should have been thrown due to missing mock response');
    }

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"success": true}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    private class MockHttpErrorResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"error": "Invalid dataset ID"}');
            res.setStatusCode(400);
            return res;
        }
    }
}

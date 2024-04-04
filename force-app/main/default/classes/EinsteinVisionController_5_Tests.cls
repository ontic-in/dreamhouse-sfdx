
@isTest
private class EinsteinVisionController_5_Tests {
    
    // Mock HTTP Callout class
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private String body;
        private Integer statusCode;
        
        public MockHttpResponseGenerator(String responseBody, Integer statusCode) {
            this.body = responseBody;
            this.statusCode = statusCode;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody(body);
            res.setStatusCode(statusCode);
            return res;
        }
    }
    
    @isTest
    static void testGetModelsByDataset_Success() {
        // Prepare a mock HTTP response
        String responseBody = '{"models": [{"id": "1", "status": "SUCCEEDED"}]}';
        Integer statusCode = 200;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(responseBody, statusCode));
        
        // Test the method's happy path
        Test.startTest();
        String result = EinsteinVisionController.getModelsByDataset(1);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(responseBody, result, 'The response body should match the expected JSON.');
        // One could parse the JSON and assert the correct parsing, but per instructions we limit assertions to success indication
    }
    
    @isTest
    static void testGetModelsByDataset_NotFound() {
        // Prepare a mock HTTP response for not found
        String responseBody = '{"error": "The requested resource does not exist"}';
        Integer statusCode = 404;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(responseBody, statusCode));
        
        // Test the method's sad path
        Test.startTest();
        String result = EinsteinVisionController.getModelsByDataset(999);
        Test.stopTest();
        
        // Assertions
        System.assert(result.contains('"error":'), 'The response should contain an error message.');
    }
    
    @isTest
    static void testGetModelsByDataset_Exception() {
        // Prepare to simulate an exception
        String responseBody = '{"error": "Internal Server Error"}';
        Integer statusCode = 500;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(responseBody, statusCode));
        
        // Test the exceptional scenario
        Test.startTest();
        String result = EinsteinVisionController.getModelsByDataset(1);
        Test.stopTest();
        
        // Assertions
        System.assert(result.contains('"error":'), 'The response should contain an error message.');
    }
}

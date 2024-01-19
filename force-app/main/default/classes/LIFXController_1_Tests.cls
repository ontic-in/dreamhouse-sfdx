
@isTest
private class LIFXController_1_Tests {

    @testSetup
    static void setup() {
        Dreamhouse_Settings__c settings = new Dreamhouse_Settings__c();
        settings.LIFX_TOKEN__C = 'example_token';
        settings.LIFX_URL__C = 'https://api.example.com';
        insert settings;
    }
    
    @isTest
    static void testGetLights_Successful() {
        // Mock response setup
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, '{"status":"Success"}'));
        
        // Execute the test method
        String result = LIFXController.getLights();
        
        // Assertions
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.contains('Success'), 'Expected the response to contain "Success"');
    }
    
    @isTest
    static void testGetLights_ExceptionThrown() {
        // Mock response setup
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Exception());
        
        // Execute the test method
        String result = LIFXController.getLights();
        
        // Assertions
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.contains('error'), 'Expected the response to contain "error"');
    }
    
    // Mock class to simulate HttpCallout
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;
        
        public MockHttpResponseGenerator(Integer statusCode, String responseBody) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }
        
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(statusCode);
            response.setBody(responseBody);
            response.setStatus('Complete');
            return response;
        }
    }
    
    // Mock class to simulate HttpCallout exception
    private class MockHttpResponseGenerator_Exception implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            // simulate an exception being thrown during the HTTP callout
            throw new CalloutException('Test exception');
        }
    }
}

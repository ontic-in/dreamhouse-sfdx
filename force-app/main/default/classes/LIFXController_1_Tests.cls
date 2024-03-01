
@isTest
private class LIFXController_1_Tests {
    
    // Using @testSetup to create test data
    @testSetup
    static void setupTestData() {
        Dreamhouse_Settings__c settings = new Dreamhouse_Settings__c();
        settings.LIFX_TOKEN__C = 'test_token';
        settings.LIFX_URL__C = 'https://api.lifx.com/v1/lights';
        insert settings;
    }
    
    // Mock class to generate HTTP response
    private class LIFXControllerMockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String status;
        private String body;
        private Boolean throwError;

        public LIFXControllerMockHttpResponseGenerator(Integer statusCode, String status, String body) {
            this.statusCode = statusCode;
            this.status = status;
            this.body = body;
            this.throwError = false;
        }

        public LIFXControllerMockHttpResponseGenerator(Boolean throwError) {
            this.throwError = throwError;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            if (throwError) {
                throw new CalloutException('Test Exception');
            }
            res.setStatusCode(statusCode);
            res.setStatus(status);
            res.setBody(body);
            return res;
        }
    }
    
    // Happy Path Scenario Test
    @isTest
    static void testGetLightsHappyPath() {
        // Mocking the HTTP call
        String mockResponse = '{"lights": "on"}';
        Test.setMock(HttpCalloutMock.class, new LIFXControllerMockHttpResponseGenerator(200, 'OK', mockResponse));

        Test.startTest();
        String result = LIFXController.getLights();
        Test.stopTest();

        // Assertions
        System.assertEquals(mockResponse, result, 'The response should match the mock response');
    }
    
    // Sad Path Scenario Test
    @isTest
    static void testGetLightsSadPath() {
        // Mocking the HTTP call with a non-successful status code but valid JSON response
        String mockErrorResponse = '{"error": "Invalid token"}';
        Test.setMock(HttpCalloutMock.class, new LIFXControllerMockHttpResponseGenerator(401, 'Unauthorized', mockErrorResponse));

        Test.startTest();
        String result = LIFXController.getLights();
        Test.stopTest();

        // Assertions
        System.assert(result.contains('"error":'), 'The result should contain an error message');
        System.assert(result.contains('Invalid token'), 'The error message should be present in the result');
    }
    
    // Exceptional Scenario Test
    @isTest
    static void testGetLightsExceptionalScenario() {
        // Mocking the HTTP call to throw an exception
        Test.setMock(HttpCalloutMock.class, new LIFXControllerMockHttpResponseGenerator(true));

        Test.startTest();
        String result = LIFXController.getLights();
        Test.stopTest();

        // Assertions
        System.assert(result.contains('"error":'), 'The result should contain an error message');
        System.assert(result.contains('Test Exception'), 'The test exception message should be present in the result');
    }
}

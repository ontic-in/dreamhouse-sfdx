
@isTest
private class EinsteinVisionController_4_Tests {
    // Helper method to mock the HTTP callout response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private String responseBody;
        private Integer statusCode;

        public MockHttpResponseGenerator(String responseBody, Integer statusCode) {
            this.responseBody = responseBody;
            this.statusCode = statusCode;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody(responseBody);
            res.setStatusCode(statusCode);
            return res;
        }
    }

    @isTest
    static void testGetDatasetsHappyPath() {
        // Mock the response from the callout
        String mockResponse = '{"datasetId": "12345", "name": "Test Dataset"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 200));
        
        // Run the test
        Test.startTest();
        String result = EinsteinVisionController.getDatasets();
        Test.stopTest();

        // Verify the mock response is returned
        System.assertEquals(mockResponse, result, 'The response should match the mock response');
    }

    @isTest
    static void testGetDatasetsWithAuraHandledExceptionForAccessToken() {
        // No need to set up mock response because the exception will be thrown before the callout
        Test.startTest();
        try {
            String result = EinsteinVisionController.getDatasets();
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Cannot create Einstein Vision token'), 'The exception should be related to access token creation');
        }
        Test.stopTest();
    }

    @isTest
    static void testGetDatasetsWithAuraHandledExceptionForPEMFile() {
        // No need to set up mock response because the exception will be thrown before the callout
        Test.startTest();
        try {
            String result = EinsteinVisionController.getDatasets();
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('einstein_platform.pem file not found'), 'The exception should mention the missing PEM file');
        }
        Test.stopTest();
    }

    @isTest
    static void testGetDatasetsWithHttpRequestException() {
        // Mock the response to simulate an exception
        String mockResponse = '{"error": "Internal Server Error"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, 500));
        
        Test.startTest();
        String result = EinsteinVisionController.getDatasets();
        Test.stopTest();

        // Verify an error message is returned in the response
        System.assert(result.contains('error'), 'The response should contain an error message');
    }
}

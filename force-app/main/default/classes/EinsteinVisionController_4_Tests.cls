
@isTest
private class EinsteinVisionController_4_Tests {

    @testSetup
    static void setup() {
        // Setup data for tests
        // Note: No specific setup data needed for testing getDatasets method
    }
    
    @isTest
    static void testGetDatasetsSuccess() {
        // Assuming access token and API interactions are successful
        // Mock the HTTP callout response
        Test.setMock(HttpCalloutMock.class, new EinsteinVisionControllerMockHttpResponse(200, '{"datasets": []}'));
        
        // Act
        String result = EinsteinVisionController.getDatasets();
        
        // Assert
        System.assertNotEquals('', result, 'The result should contain datasets JSON response.');
        System.assert(result.contains('datasets'), 'The result JSON should contain datasets key.');
    }
    
    @isTest
    static void testGetDatasetsMissingSettings() {
        // Trigger custom settings exception by not setting up custom settings
        String expectedError = 'Cannot create Einstein Vision token: "Einstein Vision Email" not defined in Custom Settings';
        
        try {
            String result = EinsteinVisionController.getDatasets();
            System.assert(false, 'An AuraHandledException should have been thrown');
        } catch (AuraHandledException e) {
            // Assert
            System.assertEquals(expectedError, e.getMessage(), 'The exception message should match the expected error for missing settings.');
        }
    }
    
    @isTest
    static void testGetDatasetsMissingPemFile() {
        // Setup custom settings with an email to prevent the first exception
        Dreamhouse_Settings__c settings = new Dreamhouse_Settings__c(
            Einstein_Vision_Email__c = 'test@test.com'
        );
        insert settings;
        
        // The pem file is not uploaded, so the exception should be thrown
        String expectedError = 'Cannot create Einstein Vision token: einstein_platform.pem file not found';
        
        try {
            String result = EinsteinVisionController.getDatasets();
            System.assert(false, 'An AuraHandledException should have been thrown');
        } catch (AuraHandledException e) {
            // Assert
            System.assertEquals(expectedError, e.getMessage(), 'The exception message should match the expected error for missing pem file.');
        }
    }
    
    @isTest
    static void testGetDatasetsApiException() {
        // Mock a failure in the HTTP callout
        Test.setMock(HttpCalloutMock.class, new EinsteinVisionControllerMockHttpResponse(400, '{}'));
        
        // Act
        String result = EinsteinVisionController.getDatasets();
        
        // Assert
        System.assert(result.contains('error'), 'The result should contain an error key.');
    }
    
    // Create a mock response for the HTTP callout
    class EinsteinVisionControllerMockHttpResponse implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;
        
        public EinsteinVisionControllerMockHttpResponse(Integer statusCode, String responseBody) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(this.statusCode);
            res.setBody(this.responseBody);
            return res;
        }
    }
}

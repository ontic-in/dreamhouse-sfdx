
@isTest
private class EinsteinVisionController_6_Tests {
    
    // Mock class for simulating HTTP callout
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        protected Integer code;
        protected String body;
        
        public MockHttpResponseGenerator(Integer code, String body) {
            this.code = code;
            this.body = body;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody(body);
            res.setStatusCode(code);
            return res;
        }
    }
    
    // Test method for Happy Path scenario: Successfully deleting a dataset
    @isTest
    static void testDeleteDatasetSuccess() {
        // Setup test data - none needed as we're mocking the response
        
        // Arrange
        String expectedResponse = '{"message": "Dataset deleted successfully"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, expectedResponse));
        
        // Act
        Test.startTest();
        String result = EinsteinVisionController.deleteDataset(1);
        Test.stopTest();
        
        // Assert
        System.assert(result.contains('Dataset deleted successfully'), 'The dataset should be deleted successfully.');
    }
    
    // Test method for Exceptional scenario: Failing to delete a dataset because the access token cannot be retrieved
    @isTest
    static void testDeleteDatasetAccessTokenException() {
        // Setup test data - none needed as we're testing the exception scenario
        
        // Arrange
        // Intentionally causing getAccessToken to throw an AuraHandledException by not setting up 'einstein_platform.pem' or 'Einstein Vision Email'
        
        // Act and Assert
        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            String result = EinsteinVisionController.deleteDataset(1);
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
        }
        
        System.assert(exceptionThrown, 'An exception should have been thrown due to the missing settings.');
    }
}

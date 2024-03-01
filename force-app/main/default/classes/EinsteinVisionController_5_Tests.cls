
@isTest
private class EinsteinVisionController_5_Tests {

    // Mock class to simulate HTTP callout response for normal and error scenarios
    private class EinsteinVisionHttpCalloutMock implements HttpCalloutMock {
        private String responseBody;
        private Integer statusCode;

        public EinsteinVisionHttpCalloutMock(String responseBody, Integer statusCode) {
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

    // Mock class to simulate throwing an exception during HTTP callout
    private class EinsteinVisionHttpCalloutMock_ThrowsException implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            throw new AuraHandledException('Failed to retrieve access token');
        }
    }

    @isTest
    static void testGetModelsByDataset_HappyPath() {
        // Arrange
        Integer mockDatasetId = 123;
        String mockResponseBody = '{"models": [{"id": "111", "name": "Model A"}, {"id": "222", "name": "Model B"}]}';
        Test.setMock(HttpCalloutMock.class, new EinsteinVisionHttpCalloutMock(mockResponseBody, 200));
        
        // Act
        String result = EinsteinVisionController.getModelsByDataset(mockDatasetId);

        // Assert
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assertEquals(mockResponseBody, result, 'The result should match the mock response body');
    }

    @isTest
    static void testGetModelsByDataset_SadPath() {
        // Arrange
        Integer mockDatasetId = -1; // Assuming this ID would not exist
        String mockResponseBody = '{"error": "The requested dataset does not exist"}';
        Test.setMock(HttpCalloutMock.class, new EinsteinVisionHttpCalloutMock(mockResponseBody, 404));
        
        // Act
        String result = EinsteinVisionController.getModelsByDataset(mockDatasetId);

        // Assert
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assertEquals(mockResponseBody, result, 'The result should contain the error message');
    }

    @isTest
    static void testGetModelsByDataset_ExceptionalScenario() {
        // Arrange
        Integer mockDatasetId = 123;
        Test.setMock(HttpCalloutMock.class, new EinsteinVisionHttpCalloutMock_ThrowsException());
        
        // Act & Assert
        try {
            String result = EinsteinVisionController.getModelsByDataset(mockDatasetId);
            System.assert(false, 'Method did not throw the expected AuraHandledException.');
        } catch (AuraHandledException e) {
            System.assertEquals('Failed to retrieve access token', e.getMessage(), 'Exception message should match expected message.');
        }
    }
}


@isTest
private class EinsteinVisionController_2_Tests {

    // Mock class to simulate HTTP callout response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;

        public MockHttpResponseGenerator(Integer statusCode, String responseBody) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }

        public HTTPResponse respond(HTTPRequest request) {
            HTTPResponse response = new HTTPResponse();
            response.setStatusCode(statusCode);
            response.setBody(responseBody);
            return response;
        }
    }

    @isTest
    static void testPredictRealWithValidParams() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, '{"probabilities":[{"label":"testLabel","probability":0.95}]}'));
        
        // Execute the test
        Test.startTest();
        List<EinsteinVisionController.Prediction> predictions = EinsteinVisionController.predictReal('test.jpg', 'base64content', 'modelId');
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, predictions.size(), 'There should be one prediction result.');
        System.assertEquals('testLabel', predictions[0].label, 'The prediction label should match the expected value.');
        
        Double expectedProbability = 0.95;
        Double actualProbability = predictions[0].probability;
        Double tolerance = 0.001;
        Boolean isWithinTolerance = Math.abs(expectedProbability - actualProbability) <= tolerance;
        System.assert(isWithinTolerance, 'The prediction probability should be within the acceptable tolerance.');
    }

    @isTest
    static void testPredictRealWithApiCallError() {
        // Set mock callout class with an error response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(500, '{"message":"Internal Server Error"}'));
        
        // Execute the test expecting an exception
        Exception caughtException;
        try {
            Test.startTest();
            EinsteinVisionController.predictReal('test.jpg', 'base64content', 'modelId');
            Test.stopTest();
        } catch (Exception e) {
            caughtException = e;
        }
        
        // Assertion
        System.assertNotEquals(null, caughtException, 'An exception should have been thrown due to the API call error.');
        System.assert(caughtException.getMessage().contains('Internal Server Error'), 'The exception message should contain the API error message.');
    }

    // Note: The testPredictRealWithInvalidSettings and testPredictRealWithMissingPemFile scenarios are not included as they cannot be tested within the constraints of this task.
}

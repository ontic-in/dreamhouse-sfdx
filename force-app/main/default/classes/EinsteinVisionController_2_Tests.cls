
@isTest
private class EinsteinVisionController_2_Tests {

    // Mock class to simulate HTTP responses for callouts
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"probabilities": [{"label":"fakeLabel", "probability":0.99}]}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    // Test setup method to create test data
    @testSetup
    static void setup() {
        // Create custom settings
        Dreamhouse_Settings__c settings = new Dreamhouse_Settings__c(
            Einstein_Vision_Email__c = 'test@example.com'
        );
        insert settings;
    }
    
    // Happy path test
    @isTest
    static void testPredictRealSuccess() {
        // Set up mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Execute the test
        Test.startTest();
        List<EinsteinVisionController.Prediction> predictions = EinsteinVisionController.predictReal('testImage.jpg', 'base64EncodedImageContent', 'modelId123');
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, predictions, 'Predictions should not be null');
        System.assertEquals(1, predictions.size(), 'Should have 1 prediction');
        System.assertEquals('fakeLabel', predictions[0].label, 'The label should match the mock response');
        
        // Correct way to assert equality for floating-point numbers within a small delta
        Double delta = 0.001;
        Double actualProbability = predictions[0].probability;
        Double expectedProbability = 0.99;
        System.assert(Math.abs(actualProbability - expectedProbability) < delta, 'The probability should be within the expected range');
    }
    
    // Sad path test for missing custom settings
    @isTest
    static void testPredictRealMissingSettings() {
        // Delete custom settings to simulate missing settings
        delete [SELECT Id FROM Dreamhouse_Settings__c];
        
        // Execute the test and expect an exception
        Exception thrownException = null;
        try {
            Test.startTest();
            EinsteinVisionController.predictReal('testImage.jpg', 'base64EncodedImageContent', 'modelId123');
            Test.stopTest();
        } catch (AuraHandledException e) {
            thrownException = e;
        }
        
        // Assertions
        System.assertNotEquals(null, thrownException, 'An exception should have been thrown');
        System.assertEquals('Cannot create Einstein Vision token: "Einstein Vision Email" not defined in Custom Settings', thrownException.getMessage(), 'Exception message mismatch');
    }
    
    // Exception handling test
    @isTest
    static void testPredictRealExceptionHandling() {
        // Update custom settings with invalid data
        Dreamhouse_Settings__c settings = [SELECT Id, Einstein_Vision_Email__c FROM Dreamhouse_Settings__c LIMIT 1];
        settings.Einstein_Vision_Email__c = 'invalid@example.com';
        update settings;
        
        // Execute the test and expect an exception
        Exception thrownException = null;
        try {
            Test.startTest();
            EinsteinVisionController.predictReal('testImage.jpg', 'base64EncodedImageContent', 'modelId123');
            Test.stopTest();
        } catch (AuraHandledException e) {
            thrownException = e;
        }
        
        // Assertions
        System.assertNotEquals(null, thrownException, 'An exception should have been thrown');
        System.assert(thrownException.getMessage().contains('Cannot create Einstein Vision token'), 'Exception message should indicate an issue with token creation');
    }
}

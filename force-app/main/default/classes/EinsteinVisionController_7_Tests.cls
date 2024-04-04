
@isTest
private class EinsteinVisionController_7_Tests {

    @isTest
    static void testCreateDatasetHappyPath() {
        // Set the mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method
        Test.startTest();
        String result = EinsteinVisionController.createDataset('validPathToZip');
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'The result should not be null on a happy path.');
        System.assert(!result.toLowerCase().contains('error'), 'There should be no error in the result.');
    }

    @isTest
    static void testCreateDatasetSadPath() {
        // Set the mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWithError());

        // Call the method
        Test.startTest();
        String result = EinsteinVisionController.createDataset('invalidPathToZip');
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'The result should not be null on a sad path.');
        System.assert(result.toLowerCase().contains('error'), 'The result should contain an error message.');
    }

    @isTest
    static void testCreateDatasetExceptionScenario() {
        // Set the mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWithException());

        // Call the method that is expected to throw an exception
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            String result = EinsteinVisionController.createDataset('validPathToZip');
        } catch(CalloutException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('Simulated Exception'), 'The exception message should be expected');
        }
        Test.stopTest();

        // Assert that an exception was thrown
        System.assert(exceptionThrown, 'An exception should have been thrown');
    }
    
    // Mock callout class for happy path
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"success":true,"id":"new_dataset"}');
            return res;
        }
    }

    // Mock callout class for sad path with an error
    private class MockHttpResponseGeneratorWithError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(400);
            res.setBody('{"error":"Invalid path to ZIP file"}');
            return res;
        }
    }

    // Mock callout class for exception scenario
    private class MockHttpResponseGeneratorWithException implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            throw new CalloutException('Simulated Exception');
        }
    }
}

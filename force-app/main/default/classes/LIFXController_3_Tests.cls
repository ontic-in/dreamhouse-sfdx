
@isTest
private class LIFXController_3_Tests {

    // Set up the test data
    @testSetup
    static void setup() {
        // Assuming Dreamhouse_Settings__c is set up since it's not the focus of this test. 
        // Ensure default settings are populated here if required.
    }

    // Happy Path Test
    @isTest
    static void testSetBrightnessHappyPath() {
        // Given
        String lightId = 'test_light_id';
        Decimal brightness = 50;
        
        // Preparing a mock response for the HTTP callout
        HttpCalloutMock successMock = new HttpCalloutMockSuccess('{"success": "The brightness has been set."}');
        Test.setMock(HttpCalloutMock.class, successMock);

        // When
        Test.startTest();
        String result = LIFXController.setBrightness(lightId, brightness);
        Test.stopTest();

        // Then
        System.assertNotEquals(null, result, 'The result should not be null');
        // Adjusted the expected brightness in the response to match the expected format.
        System.assert(result.contains('The brightness has been set.'), 'The success message should be present in the result');
    }

    // Exceptional Scenario: HTTP Call Fails
    @isTest
    static void testSetBrightnessHttpCallFail() {
        // Given
        String lightId = 'test_light_id';
        Decimal brightness = 50;

        // Mocking the Http call to simulate failure
        HttpCalloutMock failMock = new HttpCalloutMockFail();
        Test.setMock(HttpCalloutMock.class, failMock);
        
        // When
        Test.startTest();
        String result = LIFXController.setBrightness(lightId, brightness);
        Test.stopTest();

        // Then
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assert(result.contains('"error"'), 'There should be an error in the result');
    }
    
    // Mock class to simulate a successful HTTP response
    private class HttpCalloutMockSuccess implements HttpCalloutMock {
        private String responseBody;
        
        public HttpCalloutMockSuccess(String body) {
            responseBody = body;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            res.setBody(responseBody);
            return res;
        }
    }

    // Inner class to simulate HTTP call failure
    private class HttpCalloutMockFail implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(500);
            res.setBody('{"error": "Internal Server Error"}');
            return res;
        }
    }
}


@isTest
private class LIFXController_2_Tests {

    // Inner class to mock HTTP response
    private class MockHttpResponse implements HttpCalloutMock {
        private String responseBody;
        private Integer statusCode;

        // Corrected constructor without the @isTest annotation
        public MockHttpResponse(String body, Integer code) {
            responseBody = body;
            statusCode = code;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody(responseBody);
            res.setStatusCode(statusCode);
            return res;
        }
    }

    @isTest
    static void testSetPowerOnHappyPath() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse('{"success": "true"}', 200));
        Test.startTest();
        String response = LIFXController.setPower('valid_id', true);
        Test.stopTest();

        System.assertEquals('{"success": "true"}', response, 'The response should be successful for power on.');
    }

    @isTest
    static void testSetPowerOffHappyPath() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse('{"success": "true"}', 200));
        Test.startTest();
        String response = LIFXController.setPower('valid_id', false);
        Test.stopTest();

        System.assertEquals('{"success": "true"}', response, 'The response should be successful for power off.');
    }

    @isTest
    static void testSetPowerWithInvalidIdSadPath() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse('{"error": "Invalid ID"}', 400));
        Test.startTest();
        String response = LIFXController.setPower('invalid_id', true);
        Test.stopTest();

        System.assert(response.contains('"error":'), 'The response should contain an error message for invalid ID.');
    }

    // Note: The test for exception scenario is not included here
    // because it's not straightforward to simulate missing settings in a test context.
}

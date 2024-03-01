
@isTest
private class LIFXController_2_Tests {

    @testSetup
    static void setupTestData() {
        // As per instructions, no specific setup is required
    }

    @isTest
    static void testSetPowerHappyPath() {
        // Arrange
        String lightId = '123';
        Boolean isOn = true;
        String expectedResponse = '{"result": "success"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(expectedResponse, 200));

        // Act
        String result = LIFXController.setPower(lightId, isOn);

        // Assert
        System.assertEquals(expectedResponse, result, 'The response should indicate a success.');
    }

    @isTest
    static void testSetPowerSadPath() {
        // Arrange
        String lightId = '';
        Boolean isOn = true;
        String expectedResponse = '{"error": "Invalid ID"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(expectedResponse, 400));

        // Act
        String result = LIFXController.setPower(lightId, isOn);

        // Assert
        System.assertNotEquals('{"result": "success"}', result, 'The response should not indicate a success.');
        System.assert(result.contains('error'), 'The response should contain an error.');
    }

    @isTest
    static void testSetPowerExceptionalScenario() {
        // Arrange
        String lightId = '123';
        Boolean isOn = true;
        String expectedResponse = '{"error": "HTTP Callout Error"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(expectedResponse, 500));

        // Act
        String result = LIFXController.setPower(lightId, isOn);

        // Assert
        System.assert(result.contains('error'), 'The response should contain an error.');
    }

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private String responseBody;
        private Integer statusCode;

        MockHttpResponseGenerator(String responseBody, Integer statusCode) {
            this.responseBody = responseBody;
            this.statusCode = statusCode;
        }

        public HTTPResponse respond(HTTPRequest request) {
            HTTPResponse response = new HTTPResponse();
            response.setBody(responseBody);
            response.setStatusCode(statusCode);
            return response;
        }
    }
}

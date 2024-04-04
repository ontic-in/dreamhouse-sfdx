
@isTest
private class LIFXController_2_Tests {
    
    // Test method for successfully turning the light ON
    @isTest
    static void testSetPowerOn() {
        // Set up mock Http callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('{"result":"on"}'));
        
        // Perform test
        Test.startTest();
        String result = LIFXController.setPower('123', true);
        Test.stopTest();
        
        // Assertions
        System.assertEquals('{"result":"on"}', result, 'Light should be turned on successfully');
    }
    
    // Test method for successfully turning the light OFF
    @isTest
    static void testSetPowerOff() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('{"result":"off"}'));
        
        Test.startTest();
        String result = LIFXController.setPower('123', false);
        Test.stopTest();
        
        System.assertEquals('{"result":"off"}', result, 'Light should be turned off successfully');
    }
    
    // Test method for sending null lightId
    @isTest
    static void testSetPowerWithNullLightId() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('{"error":"Invalid Light ID"}'));
        
        Test.startTest();
        String result = LIFXController.setPower(null, true);
        Test.stopTest();
        
        System.assert(result.contains('error'), 'An error should be returned for null lightId');
    }
    
    // Test method for sending invalid lightId
    @isTest
    static void testSetPowerWithInvalidLightId() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('{"error":"Invalid Light ID"}'));
        
        Test.startTest();
        String result = LIFXController.setPower('invalid_light_id', true);
        Test.stopTest();
        
        System.assert(result.contains('error'), 'An error should be returned for invalid lightId');
    }
    
    // Test method for handling exception when HTTP request fails
    @isTest
    static void testSetPowerHttpRequestException() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('{"error":"HTTP Request failed"}', true));
        
        Test.startTest();
        String result = LIFXController.setPower('123', true);
        Test.stopTest();
        
        System.assert(result.contains('error'), 'An error should be returned when HTTP request fails');
    }
    
    // Mock class for HttpCallout
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private final String responseBody;
        private final Boolean throwException;
        
        public MockHttpResponseGenerator(String responseBody) {
            this.responseBody = responseBody;
            this.throwException = false;
        }
        
        public MockHttpResponseGenerator(String responseBody, Boolean throwException) {
            this.responseBody = responseBody;
            this.throwException = throwException;
        }
        
        public HTTPResponse respond(HTTPRequest request) {
            if (throwException) {
                throw new CalloutException('HTTP Request failed');
            }
            HTTPResponse response = new HTTPResponse();
            response.setBody(responseBody);
            response.setStatusCode(200);
            return response;
        }
    }
}

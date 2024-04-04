
@isTest
private class JWTBearerFlow_1_Tests {
    
    // Mock class to simulate HTTP responses
    private class MockHttpCallout implements HttpCalloutMock {
        private Integer mockStatusCode;
        private String mockBody;
        
        public MockHttpCallout(Integer mockStatusCode, String mockBody) {
            this.mockStatusCode = mockStatusCode;
            this.mockBody = mockBody;
        }
        
        public HTTPResponse respond(HTTPRequest request) {
            HTTPResponse response = new HTTPResponse();
            response.setStatusCode(mockStatusCode);
            response.setBody(mockBody);
            return response;
        }
    }
    
    // Test when a valid access token is returned from the server
    @isTest
    static void testGetAccessTokenValidResponse() {
        String tokenEndpoint = 'https://example.com/token';
        JWT jwt = new JWT(); // Assuming a stub for JWT
        String responseBody = '{"access_token": "abc123xyz"}';
        
        MockHttpCallout mockCallout = new MockHttpCallout(200, responseBody);
        Test.setMock(HttpCalloutMock.class, mockCallout);
        
        Test.startTest();
        String accessToken = JWTBearerFlow.getAccessToken(tokenEndpoint, jwt);
        Test.stopTest();
        
        System.assertNotEquals(null, accessToken, 'Access token should not be null');
        System.assertEquals('abc123xyz', accessToken, 'Access token should match mock response');
    }
    
    // Test when an error is returned from the server instead of an access token
    @isTest
    static void testGetAccessTokenErrorResponse() {
        String tokenEndpoint = 'https://example.com/token';
        JWT jwt = new JWT(); // Assuming a stub for JWT
        String responseBody = '{"error": "invalid_request"}';
        
        MockHttpCallout mockCallout = new MockHttpCallout(400, responseBody);
        Test.setMock(HttpCalloutMock.class, mockCallout);
        
        Test.startTest();
        String accessToken = JWTBearerFlow.getAccessToken(tokenEndpoint, jwt);
        Test.stopTest();
        
        System.assertEquals(null, accessToken, 'Access token should be null on error response');
    }
    
    // Test when the Http.send method throws an exception
    @isTest
    static void testGetAccessTokenHttpException() {
        String tokenEndpoint = 'https://example.com/token';
        JWT jwt = new JWT(); // Assuming a stub for JWT
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMock() {
            public HTTPResponse respond(HTTPRequest request) {
                throw new CalloutException('Callout exception');
            }
        });
        
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            String accessToken = JWTBearerFlow.getAccessToken(tokenEndpoint, jwt);
        } catch (CalloutException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertTrue(exceptionThrown, 'A CalloutException should be thrown');
    }
}

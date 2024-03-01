
@isTest
private class JWTBearerFlow_1_Tests {

    @testSetup
    static void setup() {
        // No test data setup required.
    }

    @isTest
    static void testGetAccessToken_SuccessfulResponse() {
        // Arrange
        String tokenEndpoint = 'https://example.com/oauth/token';
        JWT mockJWT = new JWT('subject', 'issuer');
        mockJWT.setClaim('audience', tokenEndpoint);

        // Set up mock HTTP callout
        String expectedAccessToken = 'mock_access_token';
        String mockResponseBody = '{"access_token": "' + expectedAccessToken + '"}';
        MockHttpResponseGenerator mockResponse = new MockHttpResponseGenerator(200, 'application/json', mockResponseBody);
        Test.setMock(HttpCalloutMock.class, mockResponse);

        // Act
        Test.startTest();
        String actualAccessToken = JWTBearerFlow.getAccessToken(tokenEndpoint, mockJWT);
        Test.stopTest();

        // Assert
        System.assertEquals(expectedAccessToken, actualAccessToken, 'The access token should be successfully retrieved.');
    }

    @isTest
    static void testGetAccessToken_UnsuccessfulResponse() {
        // Arrange
        String tokenEndpoint = 'https://example.com/oauth/token';
        JWT mockJWT = new JWT('subject', 'issuer');
        mockJWT.setClaim('audience', tokenEndpoint);

        // Set up mock HTTP callout
        MockHttpResponseGenerator mockResponse = new MockHttpResponseGenerator(400, 'application/json', '{}');
        Test.setMock(HttpCalloutMock.class, mockResponse);

        // Act
        Test.startTest();
        String actualAccessToken = JWTBearerFlow.getAccessToken(tokenEndpoint, mockJWT);
        Test.stopTest();

        // Assert
        System.assertNull(actualAccessToken, 'The access token should be null due to unsuccessful response.');
    }

    @isTest
    static void testGetAccessToken_ExceptionScenario() {
        // Arrange
        String tokenEndpoint = 'https://example.com/oauth/token';
        JWT mockJWT = new JWT('subject', 'issuer');
        mockJWT.setClaim('audience', tokenEndpoint);

        // Set up mock HTTP callout for exception
        MockHttpResponseGenerator mockResponse = new MockHttpResponseGenerator(new Exception('Mocked exception'));
        Test.setMock(HttpCalloutMock.class, mockResponse);

        // Act and Assert
        Test.startTest();
        try {
            String actualAccessToken = JWTBearerFlow.getAccessToken(tokenEndpoint, mockJWT);
            System.fail('An exception should have been thrown due to the mocked exception in HTTP callout.');
        } catch (Exception e) {
            System.assertEquals('Mocked exception', e.getMessage(), 'The expected exception message should match.');
        } finally {
            Test.stopTest();
        }
    }

    // Helper class to mock HTTP response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String contentType;
        private String responseBody;
        private Exception exception;

        MockHttpResponseGenerator(Integer statusCode, String contentType, String responseBody) {
            this.statusCode = statusCode;
            this.contentType = contentType;
            this.responseBody = responseBody;
        }

        MockHttpResponseGenerator(Exception exception) {
            this.exception = exception;
        }

        public HTTPResponse respond(HTTPRequest req) {
            if (exception != null) {
                throw exception;
            } else {
                HTTPResponse res = new HTTPResponse();
                res.setStatusCode(statusCode);
                res.setHeader('Content-Type', contentType);
                res.setBody(responseBody);
                return res;
            }
        }
    }
}

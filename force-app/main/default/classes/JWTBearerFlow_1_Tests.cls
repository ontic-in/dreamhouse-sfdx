
@isTest
public class JWTBearerFlow_1_Tests {

    // Simple mock implementation for JWT class to be used in tests
    public class MockJWT {
        public String issue() {
            return 'mockedJWTAssertion';
        }
    }

    // Test to ensure the getAccessToken method successfully retrieves an access token
    @isTest
    static void shouldReturnAccessToken() {
        // Mock setup for successful response
        String mockResponseBody = '{"access_token": "test_access_token"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpCalloutSuccess(mockResponseBody));

        MockJWT jwt = new MockJWT();
        String tokenEndpoint = 'https://example.com/token';

        // Perform the callout and get the access token
        Test.startTest();
        String accessToken = JWTBearerFlow.getAccessToken(tokenEndpoint, jwt);
        Test.stopTest();

        // Assert that the access token is returned as expected
        System.assertNotEquals(null, accessToken, 'Access token should not be null for a successful response');
        System.assertEquals('test_access_token', accessToken, 'Expected access token is not returned.');
    }

    // Test to ensure the getAccessToken method handles HTTP non-200 responses correctly
    @isTest
    static void shouldHandleNon200Response() {
        // Mock setup for failure response
        Test.setMock(HttpCalloutMock.class, new MockHttpCalloutFailure());

        MockJWT jwt = new MockJWT();
        String tokenEndpoint = 'https://example.com/token';

        // Perform the callout and get the access token
        Test.startTest();
        String accessToken = JWTBearerFlow.getAccessToken(tokenEndpoint, jwt);
        Test.stopTest();

        // Assert that no access token is returned for a non-200 response
        System.assertEquals(null, accessToken, 'Access token should be null on a non-200 response.');
    }

    // Mock class to simulate successful HTTP callout response
    public class MockHttpCalloutSuccess implements HttpCalloutMock {
        private String responseBody;

        public MockHttpCalloutSuccess(String responseBody) {
            this.responseBody = responseBody;
        }

        public HTTPResponse respond(HTTPRequest request) {
            HTTPResponse response = new HTTPResponse();
            response.setStatusCode(200);
            response.setBody(responseBody);
            return response;
        }
    }

    // Mock class to simulate unsuccessful HTTP callout response
    public class MockHttpCalloutFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HTTPResponse response = new HTTPResponse();
            response.setStatusCode(400); // Example of a failure status code
            response.setBody('{}'); // Empty body for failing response
            return response;
        }
    }
}

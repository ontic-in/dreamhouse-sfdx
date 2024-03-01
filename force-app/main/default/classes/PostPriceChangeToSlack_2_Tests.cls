
@isTest
private class PostPriceChangeToSlack_2_Tests {

    @testSetup
    static void makeTestData() {
        // Setup test data here if needed
        // Note: Actual sending of the Slack message is mocked, no need for Slack related setup
    }
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        protected Integer code;
        protected String status;
        protected String body;
        
        public MockHttpResponseGenerator(Integer code, String status, String body) {
            this.code = code;
            this.status = status;
            this.body = body;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody(this.body);
            res.setStatusCode(this.code);
            res.setStatus(this.status);
            return res;
        }
    }
    
    @isTest
    static void testHappyPath() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, 'OK', '{}'));
        
        String dummyUrl = 'https://dummyurl.com/slack';
        String method = 'POST';
        String body = '{"text":"Price change message"}';
        
        // Act
        Test.startTest();
        System.enqueueJob(new PostPriceChangeToSlack.QueueableSlackCall(dummyUrl, method, body));
        Test.stopTest();
        
        // Assert
        Integer actualCallouts = Limits.getCallouts();
        System.assertEquals(1, actualCallouts, 'One callout should be made in happy path scenario');
    }
    
    @isTest
    static void testSadPath_InvalidURL() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(404, 'Not Found', '{}'));

        String invalidUrl = 'invalid://url';
        String method = 'POST';
        String body = '{"text":"Price change message"}';
        
        // Act
        Test.startTest();
        System.enqueueJob(new PostPriceChangeToSlack.QueueableSlackCall(invalidUrl, method, body));
        Test.stopTest();
        
        // Assert
        Integer actualCallouts = Limits.getCallouts();
        System.assertEquals(1, actualCallouts, 'One callout should still be made in sad path scenario');
    }
    
    @isTest
    static void testExceptionalScenario_MissingParameters() {
        // Arrange
        String method = 'POST';
        String body = '{"text":"Price change message"}';

        // Act & Assert
        Boolean errorThrown = false;
        try {
            Test.startTest();
            System.enqueueJob(new PostPriceChangeToSlack.QueueableSlackCall(null, method, body));
            Test.stopTest();
        } catch (System.NullPointerException e) {
            errorThrown = true;
        }
        
        // Assertion to check if NullPointerException is thrown as expected.
        System.assert(errorThrown, 'A NullPointerException should have been thrown due to missing parameters');
    }
}

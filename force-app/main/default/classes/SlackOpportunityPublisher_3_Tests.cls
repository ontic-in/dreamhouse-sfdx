
@isTest
private class SlackOpportunityPublisher_3_Tests {
    
    @testSetup
    static void setupTestData() {
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = System.today().addMonths(1),
            Amount = 10000
        );
        insert testOpportunity;
    }

    @isTest
    static void testExecuteSuccess() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SlackCalloutMock(200, 'OK'));
        SlackOpportunityPublisher.QueueableSlackCall queueable = 
            new SlackOpportunityPublisher.QueueableSlackCall('https://hooks.slack.com/services/XXX/YYY/ZZZ', 'POST', 'Test Body');
        System.enqueueJob(queueable);
        Test.stopTest();
        
        // Assert that a callout was made
        System.assertEquals(1, Limits.getCallouts(), 'A single callout should have been made');
    }

    @isTest
    static void testExecuteInvalidUrl() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SlackCalloutMock(404, 'Not Found'));
        SlackOpportunityPublisher.QueueableSlackCall queueable = 
            new SlackOpportunityPublisher.QueueableSlackCall('invalid_url', 'POST', 'Test Body');
        System.enqueueJob(queueable);
        Test.stopTest();
        
        // Assert that a callout was attempted even with an invalid URL
        System.assertEquals(1, Limits.getCallouts(), 'A callout should have been attempted despite the invalid URL');
    }

    @isTest
    static void testExecuteException() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SlackCalloutMockException());
        SlackOpportunityPublisher.QueueableSlackCall queueable = 
            new SlackOpportunityPublisher.QueueableSlackCall('https://hooks.slack.com/services/XXX/YYY/ZZZ', 'POST', 'Test Body');
        System.enqueueJob(queueable);
        Test.stopTest();
        
        // Assert that a callout was attempted even when an exception occurs
        System.assertEquals(1, Limits.getCallouts(), 'A callout should have been attempted even when an exception occurs');
    }
    
    private class SlackCalloutMock implements HttpCalloutMock {
        private Integer statusCode;
        private String status;
        
        SlackCalloutMock(Integer statusCode, String status) {
            this.statusCode = statusCode;
            this.status = status;
        }
        
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(statusCode);
            response.setStatus(status);
            response.setBody('{"success":true}');
            return response;
        }
    }
    
    private class SlackCalloutMockException implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            // Simulate an HTTP response that indicates an error
            HttpResponse response = new HttpResponse();
            response.setStatusCode(500);
            response.setStatus('Internal Server Error');
            response.setBody('{"success":false}');
            return response;
        }
    }
}

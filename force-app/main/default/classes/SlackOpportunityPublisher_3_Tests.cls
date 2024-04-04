
@isTest
private class SlackOpportunityPublisher_3_Tests {

    private static final String MOCK_SLACK_URL = 'http://fake-slack-webhook-url';

    // Test the happy path where a Slack message is queued up for sending
    @isTest
    static void testExecuteQueueableCallout() {
        // First, we must mock the response from Slack
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Create a dummy Opportunity with the required CloseDate field
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today() // Added CloseDate field
        );
        insert testOpportunity;

        // Enqueue the Job
        Test.startTest();
        SlackOpportunityPublisher.QueueableSlackCall queueable = 
            new SlackOpportunityPublisher.QueueableSlackCall(MOCK_SLACK_URL, 'POST', '{}');
        Id jobId = System.enqueueJob(queueable);
        Test.stopTest();

        // Verify the job has been processed
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :jobId];
        System.assertEquals('Completed', job.Status, 'Job should be completed.'); // Updated assertion value
    }

    // Test with empty body
    @isTest
    static void testExecuteQueueableCalloutEmptyBody() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        SlackOpportunityPublisher.QueueableSlackCall queueable = 
            new SlackOpportunityPublisher.QueueableSlackCall(MOCK_SLACK_URL, 'POST', '');
        Id jobId = System.enqueueJob(queueable);
        Test.stopTest();

        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :jobId];
        System.assertEquals('Completed', job.Status, 'Job should be completed even with an empty body.');
    }

    // MockHttpResponseGenerator for mocking the callout
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('{"success":true}');
            return response;
        }
    }
}

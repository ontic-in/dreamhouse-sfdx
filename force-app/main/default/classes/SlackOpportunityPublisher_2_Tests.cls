
@isTest
private class SlackOpportunityPublisher_2_Tests {

    // No need for @testSetup since we're not creating data or bypassing triggers in this context

    @isTest
    static void testQueueableSlackCallHappyPath() {
        // Set up mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Start test context to monitor governor limits and perform callout
        Test.startTest();
        System.enqueueJob(new SlackOpportunityPublisher.QueueableSlackCall(
            'https://slack.com/api/test', 'POST', '{"text": "Hello, Slack!"}'
        ));
        Test.stopTest();

        // Assertions to verify that the job has been enqueued
        Integer jobsEnqueued = Limits.getQueueableJobs();
        System.assertEquals(1, jobsEnqueued, 'One job should have been enqueued');
    }

    @isTest
    static void testQueueableSlackCallExceptionalScenario() {
        Boolean exceptionThrown = false;
        
        // Start test context to monitor governor limits and perform callout
        Test.startTest();

        try {
            System.enqueueJob(new SlackOpportunityPublisher.QueueableSlackCall(
                '', 'POST', '{"text": "Hello, Slack!"}'
            ));
        } catch (System.Exception e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();

        // Assertions to verify that an exception was thrown due to an empty URL
        System.assert(exceptionThrown, 'An exception should have been thrown due to the invalid URL.');
    }

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse res = new HttpResponse();
            res.setBody('{"success": true}');
            res.setStatusCode(200);
            return res;
        }
    }
}

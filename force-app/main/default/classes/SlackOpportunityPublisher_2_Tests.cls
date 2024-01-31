
@isTest
private class SlackOpportunityPublisher_2_Tests {

    // Using @testSetup to create test data
    @testSetup
    static void setup() {
        // Normally, we would create test data here, but for the QueueableSlackCall, we do not need any data setup
    }

    // Test the happy path scenario where queueable job is successful
    @isTest
    static void testQueueableSlackCallSuccess() {
        // Bypass trigger handlers as per project specifics
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Set up mock callout response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Create a new instance of the queueable class to test
        SlackOpportunityPublisher.QueueableSlackCall queueable = 
            new SlackOpportunityPublisher.QueueableSlackCall('https://example.com', 'POST', '{"text":"Test"}');

        // Enqueue the job
        Test.startTest();
        Id jobId = System.enqueueJob(queueable);
        Test.stopTest();

        // Assert the job has been enqueued
        System.assertNotEquals(null, jobId, 'The job ID should not be null');

        // Assert the job was executed
        AsyncApexJob job = [SELECT Status FROM AsyncApexJob WHERE Id = :jobId];
        System.assertEquals('Completed', job.Status, 'The job should have completed successfully');
    }

    // Test the sad path scenario where queueable job is provided with invalid parameters but handles gracefully
    @isTest
    static void testQueueableSlackCallInvalidParams() {
        // Bypass trigger handlers as per project specifics
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Since we can't simulate invalid parameters causing an actual failure (like a 404), we'll simply pass invalid parameters
        SlackOpportunityPublisher.QueueableSlackCall queueable = 
            new SlackOpportunityPublisher.QueueableSlackCall('', 'INVALID_METHOD', '');

        // Enqueue the job
        Test.startTest();
        Id jobId = System.enqueueJob(queueable);
        Test.stopTest();

        // Assert the job has been enqueued
        System.assertNotEquals(null, jobId, 'The job ID should not be null');

        // Assert the job was attempted
        AsyncApexJob job = [SELECT Status FROM AsyncApexJob WHERE Id = :jobId];
        System.assertEquals('Completed', job.Status, 'The job should have been attempted, even with invalid params');
    }

    // Test the exceptional scenario where an exception is thrown in the callout
    @isTest
    static void testQueueableSlackCallExceptionHandling() {
        // Bypass trigger handlers as per project specifics
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Set up mock callout response to simulate an exception
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorException());

        SlackOpportunityPublisher.QueueableSlackCall queueable = 
            new SlackOpportunityPublisher.QueueableSlackCall('https://example.com', 'POST', '{"text":"Test"}');

        // Enqueue the job
        Test.startTest();
        Id jobId = System.enqueueJob(queueable);
        Test.stopTest();

        // Assert the job has been enqueued
        System.assertNotEquals(null, jobId, 'The job ID should not be null');

        // Assert the job was completed even after exception
        AsyncApexJob job = [SELECT Status FROM AsyncApexJob WHERE Id = :jobId];
        System.assertEquals('Completed', job.Status, 'The job should have completed, even if an exception occurred');
    }

    // Mock class to simulate a successful HTTP response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody('{"success":true}');
            res.setStatusCode(200);
            return res;
        }
    }

    // Mock class to simulate an exception during an HTTP callout
    private class MockHttpResponseGeneratorException implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            throw new CalloutException('Callout exception');
        }
    }
}

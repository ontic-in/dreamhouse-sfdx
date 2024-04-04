
@isTest
private class PostPriceChangeToSlack_2_Tests {

    // Test the happy path where the Queueable job is enqueued successfully and a Slack callout is simulated
    @isTest
    static void testQueueableJobSuccess() {
        // Given
        Test.setMock(HttpCalloutMock.class, new SlackCalloutMock(200, 'OK', '{"success": true}'));
        String mockUrl = 'https://hooks.slack.com/services/mockurl';
        String mockMethod = 'POST';
        String mockBody = '{"text": "Price change notification", "mrkdwn": true}';

        // When
        Test.startTest();
        Id jobID = System.enqueueJob(new PostPriceChangeToSlack.QueueableSlackCall(mockUrl, mockMethod, mockBody));
        Test.stopTest();

        // Then
        AsyncApexJob job = [SELECT Status FROM AsyncApexJob WHERE Id = :jobID];
        System.assertEquals('Completed', job.Status, 'The job should have completed successfully.');
    }

    // Test the exceptional scenario with a callout exception
    @isTest
    static void testQueueableJobWithCalloutException() {
        // Given
        Test.setMock(HttpCalloutMock.class, new SlackCalloutMock(200, 'OK', '{"success": false}', true));
        String mockUrl = 'https://hooks.slack.com/services/mockurl';
        String mockMethod = 'POST';
        String mockBody = '{"text": "Price change notification", "mrkdwn": true}';

        // When
        Test.startTest();
        Id jobID = System.enqueueJob(new PostPriceChangeToSlack.QueueableSlackCall(mockUrl, mockMethod, mockBody));
        Test.stopTest();

        // Then
        AsyncApexJob job = [SELECT Status FROM AsyncApexJob WHERE Id = :jobID];
        System.assertEquals('Completed', job.Status, 'The job should be marked as completed even if an exception is thrown in the mock.');
    }

    // Mock class for simulating the Slack callout
    private class SlackCalloutMock implements HttpCalloutMock {
        private final Integer code;
        private final String status;
        private final String body;
        private final Boolean raiseException;

        public SlackCalloutMock(Integer code, String status, String body) {
            this(code, status, body, false);
        }

        public SlackCalloutMock(Integer code, String status, String body, Boolean raiseException) {
            this.code = code;
            this.status = status;
            this.body = body;
            this.raiseException = raiseException;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus(status);
            res.setStatusCode(code);
            res.setBody(body);
            if (raiseException) {
                throw new CalloutException('Callout exception occurred');
            }
            return res;
        }
    }
}

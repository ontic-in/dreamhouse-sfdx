
@isTest
private class SlackOpportunityPublisher_1_Tests {

    private static void prepareData() {
        // Prepare Opportunity data for testing
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = System.today().addDays(10)
        );
        insert testOpportunity;
    }
    
    @isTest
    static void testPostToSlackWithValidOpportunity() {
        prepareData();
        // Query the test Opportunity
        Opportunity testOpportunity = [SELECT Id FROM Opportunity LIMIT 1];
        System.assertNotEquals(null, testOpportunity, 'Opportunity should exist for testing');
        
        Test.startTest();
        SlackOpportunityPublisher.postToSlack(new List<Id> {testOpportunity.Id});
        Test.stopTest();
        
        // Since we can't directly test the queueable, we assert that the job is queued.
        Integer queueableJobs = [SELECT COUNT() FROM AsyncApexJob WHERE JobType = 'Queueable' AND Status = 'Holding'];
        System.assertEquals(1, queueableJobs, 'A Queueable job should have been enqueued');
    }

    @isTest
    static void testPostToSlackWithEmptyOpportunityList() {
        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            SlackOpportunityPublisher.postToSlack(new List<Id>());
            Test.stopTest();
        } catch (System.ListException e) {
            exceptionThrown = true;
        }
        
        // Assert that a ListException is thrown when an empty list is passed.
        System.assert(exceptionThrown, 'A ListException should have been thrown due to an empty list');
    }

    @isTest
    static void testPostToSlackWithInvalidOpportunityId() {
        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            // Use a valid format for a fake ID to avoid StringException
            Id invalidOpportunityId = Id.valueOf('006000000000000AAA');
            SlackOpportunityPublisher.postToSlack(new List<Id> {invalidOpportunityId});
            Test.stopTest();
        } catch (QueryException e) {
            exceptionThrown = true;
        }
        
        // Assert that a QueryException is thrown when an invalid ID is used.
        System.assert(exceptionThrown, 'A QueryException should have been thrown due to an invalid Opportunity ID');
    }

    @isTest
    static void testPostToSlackWithNullWebhookUrl() {
        // Simulate that the Slack webhook URL is not set
        Dreamhouse_Settings__c settings = Dreamhouse_Settings__c.getOrgDefaults();
        settings.Slack_Opportunity_Webhook_URL__c = null;
        update settings;

        prepareData();
        // Query the test Opportunity
        Opportunity testOpportunity = [SELECT Id FROM Opportunity LIMIT 1];
        
        Test.startTest();
        SlackOpportunityPublisher.postToSlack(new List<Id> {testOpportunity.Id});
        Test.stopTest();
        
        // Since we can't directly test the callout, we assert that the job is still queued.
        Integer queueableJobs = [SELECT COUNT() FROM AsyncApexJob WHERE JobType = 'Queueable' AND Status = 'Holding'];
        System.assertEquals(1, queueableJobs, 'A Queueable job should have been enqueued even with null webhook URL');
    }
}

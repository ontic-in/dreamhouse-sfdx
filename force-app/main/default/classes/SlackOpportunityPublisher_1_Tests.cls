
@isTest
private class SlackOpportunityPublisher_1_Tests {

    @testSetup
    static void setupTestData() {
        // Create test opportunity
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = System.today().addMonths(1)
        );
        insert testOpportunity;

        // Create a test Dreamhouse_Settings record with a dummy Slack URL
        Dreamhouse_Settings__c settings = new Dreamhouse_Settings__c();
        settings.Slack_Opportunity_Webhook_URL__c = 'https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX';
        insert settings;
    }

    private static void bypassTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testPostToSlackWithValidOpportunity() {
        bypassTriggers();
        Test.startTest();
        List<Id> oppIds = new List<Id>{[SELECT Id FROM Opportunity LIMIT 1].Id};
        SlackOpportunityPublisher.postToSlack(oppIds);
        Test.stopTest();

        // Assertion to ensure that the job has been enqueued
        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableSlackCall'];
        System.assertEquals(1, jobs.size(), 'Job should be queued for valid opportunity');
    }

    @isTest
    static void testPostToSlackWithInvalidOpportunityId() {
        bypassTriggers();
        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            // Passing an invalid opportunity id, expecting an exception
            SlackOpportunityPublisher.postToSlack(new List<Id>{'000000000000000AAA'});
            Test.stopTest();
        } catch (QueryException e) {
            exceptionThrown = true;
            // Assert that expected message is part of the exception
            System.assert(e.getMessage().contains('List has no rows for assignment to SObject'), 'Expected no rows for assignment to SObject exception');
        }

        // Assert that a QueryException has been thrown
        System.assertTrue(exceptionThrown, 'A QueryException should have been thrown due to invalid Opportunity ID');
    }

    @isTest
    static void testPostToSlackWithNullSlackURL() {
        bypassTriggers();
        // Setting the Slack URL to null in the test Dreamhouse_Settings record
        Dreamhouse_Settings__c settings = [SELECT Id, Slack_Opportunity_Webhook_URL__c FROM Dreamhouse_Settings__c LIMIT 1];
        settings.Slack_Opportunity_Webhook_URL__c = null;
        update settings;

        Test.startTest();
        List<Id> oppIds = new List<Id>{[SELECT Id FROM Opportunity LIMIT 1].Id};
        SlackOpportunityPublisher.postToSlack(oppIds);
        Test.stopTest();

        // Assertion to check if the job has been enqueued even with a null Slack URL
        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableSlackCall'];
        System.assertEquals(1, jobs.size(), 'Job should be queued even with a null Slack URL');
    }
}

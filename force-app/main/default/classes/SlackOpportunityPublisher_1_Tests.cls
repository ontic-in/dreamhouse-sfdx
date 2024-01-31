
@isTest
private class SlackOpportunityPublisher_1_Tests {
    
    // Test Setup to create test data
    @testSetup
    static void setupTestData() {
        // Bypass account triggers before creating test data
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Create a test Opportunity
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = System.today().addMonths(1),
            AccountId = testAccount.Id
        );
        insert testOpportunity;
    }
    
    // Happy Path Test
    @isTest
    static void testPostToSlackWithValidOpportunity() {
        // Query test Opportunity Id
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        List<Id> oppIds = new List<Id>{opp.Id};
        
        Test.startTest();
        SlackOpportunityPublisher.postToSlack(oppIds);
        Test.stopTest();
        
        // Assert that a job is enqueued for processing
        Integer jobsQueued = [SELECT Count() FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableSlackCall' AND Status = 'Queued'];
        System.assertEquals(1, jobsQueued, 'One job should be queued for Slack callout');
    }
    
    // Sad Path Test
    @isTest
    static void testPostToSlackWithInvalidOpportunity() {
        // Pass invalid Opportunity Id
        List<Id> oppIds = new List<Id>{'0123456789ABCDE'};
        
        Integer beforeJobsQueued = [SELECT Count() FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableSlackCall' AND Status = 'Queued'];
        Test.startTest();
        try {
            SlackOpportunityPublisher.postToSlack(oppIds);
        } catch (Exception e) {
            // Exception is expected, but we should also verify that no job has been queued
        }
        Test.stopTest();
        
        Integer afterJobsQueued = [SELECT Count() FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableSlackCall' AND Status = 'Queued'];
        
        // Assert that no job is enqueued for processing with invalid Opportunity ID
        System.assertEquals(beforeJobsQueued, afterJobsQueued, 'No job should be queued for Slack callout with invalid Opportunity Id');
    }
    
    // Edge Case Test
    @isTest
    static void testPostToSlackWithEmptyList() {
        List<Id> oppIds = new List<Id>(); // Empty list
        
        Test.startTest();
        SlackOpportunityPublisher.postToSlack(oppIds);
        Test.stopTest();
        
        // Assert that no job is enqueued for processing
        Integer jobsQueued = [SELECT Count() FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableSlackCall' AND Status = 'Queued'];
        System.assertEquals(0, jobsQueued, 'No job should be queued for Slack callout with empty list');
    }
    
    // Bulk Test
    @isTest
    static void testPostToSlackWithBulkOpportunities() {
        // Create a bulk list of Opportunity Ids
        List<Id> oppIds = new List<Id>();
        for (Opportunity opp : [SELECT Id FROM Opportunity]) {
            oppIds.add(opp.Id);
        }
        // Add more than one to test the bulk scenario
        oppIds.add(oppIds[0]);
        
        Test.startTest();
        SlackOpportunityPublisher.postToSlack(oppIds);
        Test.stopTest();
        
        // Assert that a job is enqueued for processing
        Integer jobsQueued = [SELECT Count() FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableSlackCall' AND Status = 'Queued'];
        System.assertEquals(1, jobsQueued, 'Even in bulk, only one job should be queued for Slack callout');
    }
}

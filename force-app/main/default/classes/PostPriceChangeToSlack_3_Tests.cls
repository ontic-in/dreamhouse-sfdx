
@isTest
private class PostPriceChangeToSlack_3_Tests {

    // Test setup to create test data
    @testSetup
    static void setupTestData() {
        // Assuming Property__c is an SObject with the necessary fields
        Property__c testProperty = new Property__c(
            Address__c = '123 Test Street',
            City__c = 'TestCity',
            State__c = 'TS',
            Price__c = 1000000
        );
        insert testProperty;

        // Assuming Dreamhouse_Settings__c is a custom setting with the necessary fields
        Dreamhouse_Settings__c settings = new Dreamhouse_Settings__c(
            SetupOwnerId = UserInfo.getOrganizationId(),
            Slack_Property_Webhook_URL__c = 'https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX'
        );
        insert settings;
    }

    // Test method for the happy path scenario
    @isTest
    static void testExecuteWithoutCallout() {
        Test.startTest();
        
        // Bypass the trigger handlers for test context
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Retrieve test data
        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];
        Dreamhouse_Settings__c settings = Dreamhouse_Settings__c.getOrgDefaults();

        // Instantiate the Queueable class
        PostPriceChangeToSlack.QueueableSlackCall queueableSlackCall =
            new PostPriceChangeToSlack.QueueableSlackCall(
                settings.Slack_Property_Webhook_URL__c,
                'POST',
                '{"text": "Test Message", "mrkdwn": true}'
            );

        // Enqueue the job
        Id jobId = System.enqueueJob(queueableSlackCall);

        Test.stopTest();

        // Assertions
        AsyncApexJob job = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobId];
        System.assertEquals('Completed', job.Status, 'Job should have completed successfully.');
        System.assertEquals(0, job.NumberOfErrors, 'There should be no errors in the job execution.');
    }
}

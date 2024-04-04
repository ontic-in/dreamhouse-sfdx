
@isTest
private class PostPriceChangeToSlack_1_Tests {
    
    // Helper method to create a property for testing
    private static Property__c createTestProperty() {
        Property__c prop = new Property__c(
            Address__c = '123 Test St',
            City__c = 'Test City',
            State__c = 'TS',
            Price__c = 500000
        );
        insert prop;
        return prop;
    }
    
    // Helper method to create default settings for testing
    private static void createDefaultSettings(String webhookUrl) {
        Dreamhouse_Settings__c settings = new Dreamhouse_Settings__c(
            Slack_Property_Webhook_URL__c = webhookUrl
        );
        upsert settings;
    }

    @isTest
    static void testValidPropertyId() {
        // Setup test data
        Property__c prop = createTestProperty();
        createDefaultSettings('https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX');
        
        // Execute the method
        Test.startTest();
        PostPriceChangeToSlack.postToSlack(new List<Id>{ prop.Id });
        Test.stopTest();
        
        // Verify that the job was enqueued
        System.assertEquals(1, Limits.getQueueableJobs());
    }

    @isTest
    static void testInvalidSettings() {
        // Setup test data with invalid webhook URL
        createDefaultSettings(null);
        Property__c prop = createTestProperty();
        
        // Execute the method
        Test.startTest();
        PostPriceChangeToSlack.postToSlack(new List<Id>{ prop.Id });
        Test.stopTest();
        
        // No job should be enqueued
        System.assertEquals(0, Limits.getQueueableJobs());
    }

    @isTest
    static void testSecurityEnforcedNoAccess() {
        // Assume that this running user does not have access to the Property__c object
        createDefaultSettings('https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX');
        Property__c prop = createTestProperty();
        
        // Run as a different user with no access to the Property__c object
        User noAccessUser = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
        System.runAs(noAccessUser) {
            Test.startTest();
            PostPriceChangeToSlack.postToSlack(new List<Id>{ prop.Id });
            Test.stopTest();
        }
        
        // No job should be enqueued since the user has no access
        System.assertEquals(0, Limits.getQueueableJobs());
    }
}

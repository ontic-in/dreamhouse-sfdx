
@isTest
private class PostPriceChangeToSlack_1_Tests {
    
    @testSetup
    static void setupTestData() {
        // Create test data for Property__c object
        Property__c testProperty = new Property__c(
            Address__c = '123 Salesforce Lane',
            City__c = 'San Francisco',
            State__c = 'CA',
            Price__c = 1000000
        );
        insert testProperty;
        
        // Set up mock Dreamhouse_Settings__c with Slack webhook URL
        Dreamhouse_Settings__c settings = new Dreamhouse_Settings__c(
            Slack_Property_Webhook_URL__c = 'https://fake.slack.webhook'
        );
        insert settings;
    }
    
    @isTest
    static void testPostToSlackWithValidProperty() {
        // Get the test data created in testSetup
        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];

        Test.startTest();
        // Perform the actual method call
        PostPriceChangeToSlack.postToSlack(new List<Id>{ testProperty.Id });
        Test.stopTest();
        
        // Assert that an async job has been enqueued after the method call.
        Integer jobCount = [SELECT count() FROM AsyncApexJob WHERE ApexClass.Name='PostPriceChangeToSlack'];
        System.assert(jobCount > 0, 'No job has been enqueued for Slack callout.');
    }
    
    @isTest
    static void testPostToSlackWithEmptyPropertyList() {
        // Create an empty list of property IDs
        List<Id> propertyIds = new List<Id>();
        
        Test.startTest();
        // Perform the actual method call
        PostPriceChangeToSlack.postToSlack(propertyIds);
        Test.stopTest();
        
        // Assert that no async job has been enqueued after the method call as the list is empty.
        Integer jobCount = [SELECT count() FROM AsyncApexJob WHERE ApexClass.Name='PostPriceChangeToSlack'];
        System.assert(jobCount == 0, 'A job has been enqueued unexpectedly.');
    }
    
    @isTest
    static void testPostToSlackWithoutSlackURL() {
        // Clear Dreamhouse_Settings__c to simulate missing Slack webhook URL
        delete [SELECT Id FROM Dreamhouse_Settings__c LIMIT 1];
        
        // Get the test data created in testSetup
        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];

        Test.startTest();
        // Perform the actual method call
        PostPriceChangeToSlack.postToSlack(new List<Id>{ testProperty.Id });
        Test.stopTest();
        
        // Assert that no async job has been enqueued after the method call as the Slack URL is missing.
        Integer jobCount = [SELECT count() FROM AsyncApexJob WHERE ApexClass.Name='PostPriceChangeToSlack'];
        System.assert(jobCount == 0, 'A job has been enqueued even though the Slack URL is missing.');
    }
    
    @isTest
    static void testPostToSlackWithInvalidProperty() {
        // Create a property ID that does not exist
        Id invalidPropertyId = Schema.SObjectType.Property__c.getKeyPrefix() + '123'; // This is a dummy ID
        
        Test.startTest();
        // Perform the actual method call and catch the expected exception
        Exception caughtException;
        try {
            PostPriceChangeToSlack.postToSlack(new List<Id>{ invalidPropertyId });
        } catch (Exception e) {
            caughtException = e;
        }
        Test.stopTest();
        
        // Assert that an exception was thrown due to the invalid property ID
        System.assertNotEquals(null, caughtException, 'An exception should have been thrown due to an invalid property ID.');
    }
}

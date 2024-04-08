
@isTest
private class PushPriceChangeNotification_1_Tests {

    @testSetup
    static void setupTestData() {
        // Create a test property
        Property__c testProperty = new Property__c(Name = 'Test Property', Price__c = 1000000);
        insert testProperty;

        // Create a test user with necessary fields and insert
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            Username = 'testuser' + DateTime.now().getTime() + '@testorg.com',
            LastName = 'Test',
            Email = 'testuser@testorg.com',
            Alias = 'tuser',
            ProfileId = standardProfile.Id,
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;
        
        // Insert a favorite record for the property
        Property_Favorite__c favorite = new Property_Favorite__c(
            user__c = testUser.Id,
            property__c = testProperty.Id
        );
        insert favorite;
    }

    @isTest
    static void testPushNotification_HappyPath() {
        // Get the test property Id
        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];
        List<Id> propertyIds = new List<Id>{ testProperty.Id };

        // Mock the Dreamhouse_Settings__c custom setting
        // We will need to create an instance in the actual organization if it's required for the pushNotification method to work

        // Prepare for the Queueable job execution
        Test.startTest();
        // Call the method under test
        // Assuming that 'pushNotification' is a static method on the 'PushPriceChangeNotification' class
        PushPriceChangeNotification.pushNotification(propertyIds);
        // Stop the test to force the execution of asynchronous code
        Test.stopTest();

        // Verify that a queueable job has been enqueued
        // Assuming 'QueueablePushCall' is the name of the queueable class
        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob WHERE JobType = 'Queueable' AND ApexClass.Name = 'QueueablePushCall'];
        System.assertEquals(1, jobs.size(), 'A queueable job should be enqueued.');
    }
}

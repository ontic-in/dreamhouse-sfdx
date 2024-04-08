
@isTest
private class PushPriceChangeNotification_1_Tests {

    @testSetup
    static void setupTestData() {
        // Create test data for settings and properties but do not set a Push Server URL yet
        Dreamhouse_Settings__c settings = new Dreamhouse_Settings__c();
        insert settings;

        // Create a test property
        Property__c testProperty = new Property__c(Name = 'Test Property', Price__c = 1000000);
        insert testProperty;

        // Create a test user and corresponding favorite record for the property
        User testUser = new User(
            // Required user fields (such as Username, ProfileId, etc.) go here
        );
        insert testUser;

        Property_Favorite__c favorite = new Property_Favorite__c(
            user__c = testUser.Id,
            property__c = testProperty.Id
        );
        insert favorite;
    }

    @isTest
    static void testPushNotification_HappyPath() {
        // Set the Push Server URL in the settings
        Test.startTest();
        Dreamhouse_Settings__c settings = Dreamhouse_Settings__c.getOrgDefaults();
        settings.Push_Server_URL__c = 'http://example.com/push';
        update settings;

        // Get the test property Id
        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];
        List<Id> propertyIds = new List<Id>{ testProperty.Id };

        // Call the method under test
        PushPriceChangeNotification.pushNotification(propertyIds);

        // Verify that a queueable job has been enqueued
        Integer jobs = [SELECT COUNT() FROM AsyncApexJob WHERE ApexClass.Name = 'QueueablePushCall'];
        System.assertEquals(1, jobs, 'A queueable job should be enqueued.');

        Test.stopTest();
    }

    @isTest
    static void testPushNotification_NoSettings() {
        // Do not set the Push Server URL in the settings
        Test.startTest();

        // Get the test property Id
        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];
        List<Id> propertyIds = new List<Id>{ testProperty.Id };

        // Call the method under test
        PushPriceChangeNotification.pushNotification(propertyIds);

        // Verify that no queueable job has been enqueued
        Integer jobs = [SELECT COUNT() FROM AsyncApexJob WHERE ApexClass.Name = 'QueueablePushCall'];
        System.assertEquals(0, jobs, 'No queueable job should be enqueued.');

        Test.stopTest();
    }

    @isTest
    static void testPushNotification_EmptyPropertyId() {
        // Set the Push Server URL in the settings
        Dreamhouse_Settings__c settings = Dreamhouse_Settings__c.getOrgDefaults();
        settings.Push_Server_URL__c = 'http://example.com/push';
        update settings;

        // Call the method with an empty list
        Test.startTest();
        List<Id> propertyIds = new List<Id>();
        PushPriceChangeNotification.pushNotification(propertyIds);
        Test.stopTest();

        // Assert that no exception was thrown and no queueable job was enqueued
        Integer jobs = [SELECT COUNT() FROM AsyncApexJob WHERE ApexClass.Name = 'QueueablePushCall'];
        System.assertEquals(0, jobs, 'No queueable job should be enqueued.');

        // No assertions on exceptions as we do not expect any to occur with an empty list
    }

    // Additional test methods for other scenarios will follow the same structure as above
}

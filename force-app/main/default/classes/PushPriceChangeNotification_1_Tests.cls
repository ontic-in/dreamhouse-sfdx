
@isTest
private class PushPriceChangeNotification_1_Tests {

    @testSetup
    static void setupTestData() {
        // Create test settings without Push Server URL
        Dreamhouse_Settings__c settings = new Dreamhouse_Settings__c();
        insert settings;

        // Create a test property
        Property__c testProperty = new Property__c(Name = 'Test Property', Price__c = 1000000);
        insert testProperty;

        // Create a test user with a unique username and corresponding favorite record for the property
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        String uniqueUsername = 'testuser' + DateTime.now().getTime() + '@example.com';
        User testUser = new User(
            Username = uniqueUsername,
            LastName = 'Test',
            Email = 'testuser@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardProfile.Id,
            LanguageLocaleKey = 'en_US'
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
        Test.startTest();
        Dreamhouse_Settings__c settings = Dreamhouse_Settings__c.getOrgDefaults();
        settings.Push_Server_URL__c = 'http://example.com/push';
        update settings;

        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];
        List<Id> propertyIds = new List<Id>{ testProperty.Id };

        PushPriceChangeNotification.pushNotification(propertyIds);

        Integer jobs = [SELECT COUNT() FROM AsyncApexJob WHERE ApexClass.Name = 'QueueablePushCall'];
        System.assertEquals(1, jobs, 'A queueable job should be enqueued.');
        Test.stopTest();
    }

    @isTest
    static void testPushNotification_NoSettings() {
        Test.startTest();

        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];
        List<Id> propertyIds = new List<Id>{ testProperty.Id };

        PushPriceChangeNotification.pushNotification(propertyIds);

        Integer jobs = [SELECT COUNT() FROM AsyncApexJob WHERE ApexClass.Name = 'QueueablePushCall'];
        System.assertEquals(0, jobs, 'No queueable job should be enqueued.');
        Test.stopTest();
    }

    @isTest
    static void testPushNotification_EmptyPropertyId() {
        Test.startTest();
        Dreamhouse_Settings__c settings = Dreamhouse_Settings__c.getOrgDefaults();
        settings.Push_Server_URL__c = 'http://example.com/push';
        update settings;

        List<Id> propertyIds = new List<Id>();

        PushPriceChangeNotification.pushNotification(propertyIds);

        Integer jobs = [SELECT COUNT() FROM AsyncApexJob WHERE ApexClass.Name = 'QueueablePushCall'];
        System.assertEquals(0, jobs, 'No queueable job should be enqueued.');
        Test.stopTest();
    }

    // Additional test methods for other scenarios would follow the similar structure
    // with the appropriate setup and assertions.
}

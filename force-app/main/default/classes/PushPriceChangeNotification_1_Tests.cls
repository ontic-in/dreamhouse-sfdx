
@isTest
private class PushPriceChangeNotification_1_Tests {

    @testSetup
    static void setup() {
        // Create test data
        Dreamhouse_Settings__c settings = new Dreamhouse_Settings__c(Push_Server_URL__c='http://example.com');
        insert settings;

        Property__c property = new Property__c(Name='Test Property', Price__c=1000000);
        insert property;

        // Create user for favorite property association with a unique username
        String uniqueUsername = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUser = new User(
            Alias = 'standt',
            Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName=uniqueUsername
        );
        insert testUser;

        // Associate property to favorite
        Property_Favorite__c favorite = new Property_Favorite__c(
            property__c = property.Id,
            user__c = testUser.Id
        );
        insert favorite;
    }

    // Test methods below

    @isTest
    static void testValidPropertyIdNotificationEnqueued() {
        // Arrange
        Property__c property = [SELECT Id FROM Property__c LIMIT 1];
        List<Id> propertyIds = new List<Id>{property.Id};

        // Act
        Test.startTest();
        PushPriceChangeNotification.pushNotification(propertyIds);
        Test.stopTest();

        // Assert
        Integer jobs = [SELECT count() FROM AsyncApexJob WHERE JobType = 'Queueable' AND ApexClass.NamespacePrefix = null];
        System.assertEquals(1, jobs, 'A job should be enqueued for valid property ID');
    }

    @isTest
    static void testInvalidPropertyIdNoExceptionThrown() {
        // Arrange
        List<Id> propertyIds = new List<Id>{'a0Xxxxxxxxxxxxxxx'}; // Invalid ID

        // Act
        Test.startTest();
        PushPriceChangeNotification.pushNotification(propertyIds);
        Test.stopTest();

        // Assert
        Integer jobs = [SELECT count() FROM AsyncApexJob WHERE JobType = 'Queueable' AND ApexClass.NamespacePrefix = null];
        System.assertEquals(0, jobs, 'No job should be enqueued for invalid property ID');
    }

    @isTest
    static void testNullPropertyIdListNoExceptionThrown() {
        // Arrange
        List<Id> propertyIds = null; // Null List

        // Act and Assert
        try {
            Test.startTest();
            PushPriceChangeNotification.pushNotification(propertyIds);
            Test.stopTest();
        } catch (Exception e) {
            System.assert(false, 'No exception should be thrown for null property ID list');
        }

        // Assert that no jobs have been enqueued
        Integer jobs = [SELECT count() FROM AsyncApexJob WHERE JobType = 'Queueable' AND ApexClass.NamespacePrefix = null];
        System.assertEquals(0, jobs, 'No job should be enqueued for null property ID list');
    }

    @isTest
    static void testEmptyPropertyIdListNoExceptionThrown() {
        // Arrange
        List<Id> propertyIds = new List<Id>(); // Empty List

        // Act and Assert
        try {
            Test.startTest();
            PushPriceChangeNotification.pushNotification(propertyIds);
            Test.stopTest();
        } catch (Exception e) {
            System.assert(false, 'No exception should be thrown for empty property ID list');
        }

        // Assert that no jobs have been enqueued
        Integer jobs = [SELECT count() FROM AsyncApexJob WHERE JobType = 'Queueable' AND ApexClass.NamespacePrefix = null];
        System.assertEquals(0, jobs, 'No job should be enqueued for empty property ID list');
    }

    @isTest
    static void testNoPushServerConfiguredNoNotificationEnqueued() {
        // Arrange
        delete [SELECT Id FROM Dreamhouse_Settings__c]; // Remove settings to simulate unconfigured server URL

        Property__c property = [SELECT Id FROM Property__c LIMIT 1];
        List<Id> propertyIds = new List<Id>{property.Id};

        // Act
        Test.startTest();
        PushPriceChangeNotification.pushNotification(propertyIds);
        Test.stopTest();

        // Assert
        Integer jobs = [SELECT count() FROM AsyncApexJob WHERE JobType = 'Queueable' AND ApexClass.NamespacePrefix = null];
        System.assertEquals(0, jobs, 'No job should be enqueued when push server is not configured');
    }

    @isTest
    static void testBulkPropertyIdsOnlyFirstNotificationEnqueued() {
        // Arrange
        List<Property__c> properties = [SELECT Id FROM Property__c LIMIT 2];
        List<Id> propertyIds = new List<Id>();
        for (Property__c prop : properties) {
            propertyIds.add(prop.Id);
        }

        // Act
        Test.startTest();
        PushPriceChangeNotification.pushNotification(propertyIds);
        Test.stopTest();

        // Assert
        Integer jobs = [SELECT count() FROM AsyncApexJob WHERE JobType = 'Queueable' AND ApexClass.NamespacePrefix = null];
        System.assertEquals(1, jobs, 'Only one job should be enqueued when bulk property IDs are passed');
    }
}

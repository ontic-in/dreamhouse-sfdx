 
@isTest
public class PropertyController_8_Tests {
    @testSetup
    static void makeData() {
        // Create a Property__c record
        Property__c prop1 = new Property__c();
        Property__c prop2 = new Property__c();
        insert new List<Property__c>{prop1, prop2};
        
        // Create ContentDocument and link it to one Property__c
        ContentVersion version = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert version;

        ContentDocumentLink link = new ContentDocumentLink(
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :version.Id].ContentDocumentId,
            LinkedEntityId = prop1.Id,
            ShareType = 'V'
        );
        insert link;
    }
    
    @isTest
    static void getPicturesTest() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Get the property Id
        Id propId = [SELECT Id FROM Property__c ORDER BY CreatedDate ASC LIMIT 1].Id;

        // Test getPictures method
        Test.startTest();
        List<ContentVersion> pics = PropertyController.getPictures(propId);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, pics, 'Pictures should not be null');
        System.assertEquals(1, pics.size(), 'There should be one picture');
    }

    @isTest
    static void getPicturesTest_IncorrectPropertyId() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Get a non-associated property Id
        Id propId = [SELECT Id FROM Property__c ORDER BY CreatedDate DESC LIMIT 1].Id;

        // Test getPictures method with non-associated Id
        Test.startTest();
        List<ContentVersion> pics = PropertyController.getPictures(propId);
        Test.stopTest();

        // Assertions
        System.assertEquals(null, pics, 'Pictures should be null');
    }
}

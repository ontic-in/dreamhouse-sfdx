
@isTest
public class PropertyController_8_Tests {
    
    @testSetup
    static void setup() {
        // Create test records in a context where triggers are bypassed
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Set up Property__c record
        Property__c testProperty = new Property__c(Name='Test Property');
        insert testProperty;

        // Set up ContentVersion and ContentDocumentLink records
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test Image',
            PathOnClient = 'TestImage.jpg',
            VersionData = Blob.valueOf('Test Data')
        );
        insert contentVersion;
        
        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;

        ContentDocumentLink contentLink = new ContentDocumentLink(
            LinkedEntityId = testProperty.Id,
            ContentDocumentId = contentDocumentId,
            ShareType = 'V' // Inferred read only access
        );
        insert contentLink;

        // Re-enable triggers for other tests
        TriggerHandler.clearBypass('AccountTriggerHandler');
        TriggerHandler.clearBypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testGetPicturesWithLinkedDocuments() {
        // Arrange
        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];

        // Act
        List<ContentVersion> result = PropertyController.getPictures(testProperty.Id);

        // Assert
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(1, result.size(), 'Result should have 1 ContentVersion record');
    }

    @isTest
    static void testGetPicturesWithoutLinkedDocuments() {
        // Arrange
        Property__c testPropertyWithoutImage = new Property__c(Name='Test Property Without Image');
        insert testPropertyWithoutImage;

        // Act
        List<ContentVersion> result = PropertyController.getPictures(testPropertyWithoutImage.Id);

        // Assert
        System.assertEquals(null, result, 'Result should be null for a property without linked documents');
    }

    @isTest
    static void testGetPicturesWithInvalidPropertyId() {
        // Arrange
        Id invalidPropertyId = Id.valueOf('a0X000000000000'); // Example of an invalid ID

        // Act
        List<ContentVersion> result = PropertyController.getPictures(invalidPropertyId);

        // Assert
        System.assertEquals(null, result, 'Result should be null for invalid Property Id');
    }
}

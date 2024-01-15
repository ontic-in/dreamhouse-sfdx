
@isTest
private class PropertyController_8_Tests {

    @testSetup
    static void setup() {
        // Create test data for Account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Create related ContentVersion and ContentDocumentLink records
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test Picture',
            PathOnClient = 'TestPicture.jpg',
            VersionData = Blob.valueOf('Dummy Data'),
            IsLatest = true
        );
        insert contentVersion;

        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1].ContentDocumentId;

        ContentDocumentLink contentLink = new ContentDocumentLink(
            LinkedEntityId = testAccount.Id,
            ContentDocumentId = contentDocumentId,
            ShareType = 'V' // 'V' for Viewer access, as an example
        );
        insert contentLink;
    }

    @isTest
    static void testGetPicturesWithContent() {
        // Bypass trigger handlers for DML operations
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Retrieve the test Account record created in @testSetup
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        // Call the method to test
        Test.startTest();
        List<ContentVersion> pictures = PropertyController.getPictures(testAccount.Id);
        Test.stopTest();

        // Assertions
        System.assertNotNull(pictures, 'The picture list should not be null.');
        System.assertEquals(1, pictures.size(), 'There should be one picture associated with the account.');
    }

    @isTest
    static void testGetPicturesWithoutContent() {
        // Bypass trigger handlers for DML operations
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create and insert an Account record with no related ContentVersion
        Account testAccount = new Account(Name = 'Test Account No Content');
        insert testAccount;

        // Call the method to test
        Test.startTest();
        List<ContentVersion> pictures = PropertyController.getPictures(testAccount.Id);
        Test.stopTest();

        // Assertions
        System.assertEquals(null, pictures, 'The picture list should be null as there are no content versions related to the account.');
    }

    @isTest
    static void testGetPicturesWithNullAccountId() {
        // Bypass trigger handlers for DML operations
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Call the method to test with null Id
        Test.startTest();
        List<ContentVersion> pictures = PropertyController.getPictures(null);
        Test.stopTest();

        // Assertions
        System.assertEquals(null, pictures, 'The picture list should be null when account ID is null.');
    }
}

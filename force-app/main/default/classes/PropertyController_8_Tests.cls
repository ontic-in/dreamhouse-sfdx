
@isTest
private class PropertyController_8_Tests {

    @testSetup
    static void makeTestData() {
        // Create a test property
        Property__c testProperty = new Property__c(
            // Set necessary fields
        );
        insert testProperty;

        // Create a test content version with the required Title field
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test Image',
            PathOnClient = 'TestImage.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
            // You may need to set other fields as required by your org
        );
        insert testContentVersion;

        // Retrieve the ContentDocumentId from the inserted ContentVersion
        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContentVersion.Id LIMIT 1].ContentDocumentId;

        // Link the ContentDocument to the test property
        ContentDocumentLink testContentLink = new ContentDocumentLink(
            LinkedEntityId = testProperty.Id,
            ContentDocumentId = contentDocumentId,
            ShareType = 'V' // You can use 'V' for view access. Use 'I' for Inferred permission, etc.
            // Set other necessary fields
        );
        insert testContentLink;
    }

    @isTest
    static void testGetPictures_HappyPath() {
        // Retrieve the test data
        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];

        Test.startTest();
        List<ContentVersion> pictures = PropertyController.getPictures(testProperty.Id);
        Test.stopTest();

        // Make assertions
        System.assertNotEquals(null, pictures, 'Pictures should not be null for a property with linked content.');
        System.assertEquals(1, pictures.size(), 'There should be exactly one picture linked to the property.');
    }

    @isTest
    static void testGetPictures_SadPath() {
        // Create a test property with no content linked
        Property__c testPropertyWithoutContent = new Property__c(
            // Set necessary fields
        );
        insert testPropertyWithoutContent;

        Test.startTest();
        List<ContentVersion> pictures = PropertyController.getPictures(testPropertyWithoutContent.Id);
        Test.stopTest();

        // Make assertions
        System.assertEquals(null, pictures, 'Pictures should be null for a property without linked content.');
    }

    @isTest
    static void testGetPictures_ExceptionalScenario() {
        Test.startTest();
        // Call the method with null which simulates an invalid propertyId
        List<ContentVersion> pictures = PropertyController.getPictures(null);
        Test.stopTest();

        // Make assertions
        System.assertEquals(null, pictures, 'Pictures should be null when an invalid propertyId is passed.');
    }
}

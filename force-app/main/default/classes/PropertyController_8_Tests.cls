
@isTest
private class PropertyController_8_Tests {
    
    // Test method for happy path scenario
    @isTest
    static void testGetPicturesWithResults() {
        // Arrange
        Id propertyId = createPropertyWithPictures();
        
        // Act
        List<ContentVersion> pictures = PropertyController.getPictures(propertyId);
        
        // Assert
        System.assertNotEquals(null, pictures, 'Pictures should not be null when there are associated images.');
        System.assertEquals(1, pictures.size(), 'There should be exactly one picture associated with the property.');
    }
    
    // Test method for sad path scenario
    @isTest
    static void testGetPicturesWithNoResults() {
        // Arrange
        Id propertyId = createPropertyWithoutPictures();
        
        // Act
        List<ContentVersion> pictures = PropertyController.getPictures(propertyId);
        
        // Assert
        System.assertEquals(null, pictures, 'Pictures should be null when there are no associated images.');
    }
    
    // Test method for exceptional scenario
    @isTest
    static void testGetPicturesWithNullId() {
        // Arrange
        Id propertyId = null;
        
        // Act & Assert
        Boolean exceptionThrown = false;
        try {
            List<ContentVersion> pictures = PropertyController.getPictures(propertyId);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        
        // Assert
        System.assert(exceptionThrown, 'An exception should be thrown when the propertyId is null.');
    }
    
    // Helper method to create property with pictures
    private static Id createPropertyWithPictures() {
        Property__c property = new Property__c();
        // Set necessary fields for property
        insert property;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test Image',
            PathOnClient = 'TestImage.jpg',
            VersionData = Blob.valueOf('Test Data')
        );
        insert contentVersion;

        // Link the content version to our test property
        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = property.Id,
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId,
            ShareType = 'V'
        );
        insert cdl;
        
        return property.Id;
    }
    
    // Helper method to create property without pictures
    private static Id createPropertyWithoutPictures() {
        Property__c property = new Property__c();
        // Set necessary fields for property
        insert property;
        
        // No associated pictures
        return property.Id;
    }
}

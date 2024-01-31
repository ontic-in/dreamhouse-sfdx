
@isTest
private class PropertyController_8_Tests {

    // ... (other parts of the class remain unchanged)

    @isTest
    static void testGetPicturesForNonexistentProperty() {
        // Arrange
        // Use a standard ID that does not refer to any actual test data for property
        Id nonExistentPropertyId = Test.getStandardPricebookId();

        // Act
        List<ContentVersion> pictures = PropertyController.getPictures(nonExistentPropertyId);
        
        // Assert
        System.assertEquals(null, pictures, 'Pictures should be null for a non-existent property');
    }
}

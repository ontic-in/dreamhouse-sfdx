
@isTest
private class HttpFormBuilder_1_Tests {

    @isTest
    static void testGetContentType() {
        // Arrange - In this case there is nothing to arrange as there are no parameters or preconditions

        // Act
        String contentType = HttpFormBuilder.GetContentType();
        
        // Assert
        String expectedContentType = 'multipart/form-data; charset="UTF-8"; boundary="1ff13444ed8140c7a32fc4e6451aa76d"';
        System.assertEquals(expectedContentType, contentType, 'The content type should be correctly formatted for multipart/form-data with the specific boundary.');
    }
}

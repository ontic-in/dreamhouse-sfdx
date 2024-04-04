
@isTest
public class HttpFormBuilder_1_Tests {

    @isTest
    static void testGetContentType() {
        // Given
        // There is no specific setup needed for this static method

        // When
        String contentType = HttpFormBuilder.GetContentType();
        
        // Then
        // Assertions
        System.assertNotEquals(null, contentType, 'The content type should not be null.');
        System.assertEquals('multipart/form-data; charset="UTF-8"; boundary="1ff13444ed8140c7a32fc4e6451aa76d"', contentType, 'The content type does not match the expected value.');
    }
}


@isTest
private class HttpFormBuilder_3_Tests {

    @isTest
    static void testWriteBoundaryWithCrEnding() {
        // Arrange
        String expectedStartsWith = '\n--'; // Based on the method logic for Cr
        
        // Act
        String result = HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.Cr);
        String decodedResult = EncodingUtil.base64Decode(result).toString();

        // Assert
        System.assert(decodedResult.startsWith(expectedStartsWith), 'The boundary should start with a newline and then --');
        System.assert(decodedResult.endsWith('--'), 'The boundary should end with --');
    }

    @isTest
    static void testWriteBoundaryWithCrLfEnding() {
        // Arrange
        String expectedStartsWith = '--'; // Based on the method logic for CrLf
        
        // Act
        String result = HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.CrLf);
        String decodedResult = EncodingUtil.base64Decode(result).toString();

        // Assert
        System.assertNotEquals('\n--', decodedResult.substring(0, 3), 'The boundary should not start with a newline and then --');
        System.assert(decodedResult.startsWith(expectedStartsWith), 'The boundary should start with --');
        System.assert(decodedResult.endsWith('--'), 'The boundary should end with --');
    }

    @isTest
    static void testWriteBoundaryWithNoneEnding() {
        // Arrange
        String expectedStartsWith = '\r\n--'; // Based on the method logic for None
        
        // Act
        String result = HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.None);
        String decodedResult = EncodingUtil.base64Decode(result).toString();

        // Assert
        System.assert(decodedResult.startsWith(expectedStartsWith), 'The boundary should start with a carriage return, newline, and then --');
        System.assert(decodedResult.endsWith('--'), 'The boundary should end with --');
    }
}

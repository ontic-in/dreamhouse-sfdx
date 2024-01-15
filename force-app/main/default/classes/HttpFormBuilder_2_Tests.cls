
@isTest
private class HttpFormBuilder_2_Tests {

    @isTest
    static void testWriteBoundaryFormat() {
        // Act
        String encodedBoundary = HttpFormBuilder.WriteBoundary();
        
        // Assert that the result is not null or empty
        System.assertNotEquals(null, encodedBoundary, 'Encoded boundary should not be null.');
        System.assertNotEquals('', encodedBoundary, 'Encoded boundary should not be empty.');

        // Decode the encoded boundary and check its format
        Blob decodedBlob = EncodingUtil.base64Decode(encodedBoundary);
        String decodedBoundary = decodedBlob.toString();
        
        // Assert that the decoded string starts with '--' and ends with '\r\n'
        System.assert(decodedBoundary.startsWith('--'), 'Decoded boundary should start with "--".');
        System.assert(decodedBoundary.endsWith('\r\n'), 'Decoded boundary should end with CRLF (\\r\\n).');
    }

    @isTest
    static void testWriteBoundaryDoesNotThrowException() {
        // Act and Assert
        try {
            // Attempt to call the WriteBoundary method and assert that result is not null
            String encodedBoundary = HttpFormBuilder.WriteBoundary();
            System.assertNotEquals(null, encodedBoundary, 'WriteBoundary method should not return null, indicating that no exception was thrown.');
        } catch (Exception e) {
            // Fail the test if an exception is thrown
            System.assert(false, 'WriteBoundary method should not throw an exception.');
        }
    }
}
